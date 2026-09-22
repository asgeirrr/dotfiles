#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path

import yaml


def parse_args():
    parser = argparse.ArgumentParser(
        description="Build a Podman image from a resolved docker-compose service"
    )
    parser.add_argument(
        "service",
        nargs="?",
        default="app",
        help="Service name defined in docker-compose.yml (default: app)",
    )
    parser.add_argument(
        "-f",
        "--file",
        default="docker-compose.yml",
        help="Path to docker-compose.yml (default: docker-compose.yml)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print the build command without executing it",
    )
    return parser.parse_args()


def load_resolved_compose(compose_file: str) -> dict:
    """Use `docker compose config` to get resolved Compose config."""
    result = subprocess.run(
        ["docker", "compose", "-f", compose_file, "config"],
        capture_output=True,
        text=True,
        check=True,
    )
    return yaml.safe_load(result.stdout)


def main():
    args = parse_args()
    compose_file = args.file
    service_name = args.service

    if not Path(compose_file).is_file():
        print(f"❌ {compose_file} not found.")
        sys.exit(1)

    config = load_resolved_compose(compose_file)
    services = config.get("services", {})

    if service_name not in services:
        print(f"❌ Service '{service_name}' not found in resolved config.")
        sys.exit(1)

    service = services[service_name]
    build = service.get("build")

    if not build:
        print(f"❌ No build section found for service '{service_name}'.")
        sys.exit(1)

    context = build.get("context", ".")
    dockerfile = build.get("dockerfile", "Dockerfile")
    args_dict = build.get("args", {})
    secrets_list = build.get("secrets", [])
    project_name = config.get("name", Path(compose_file).parent.name)
    image = service.get("image", f"{project_name}-{service_name}:latest")

    # Resolve dockerfile path relative to context (podman expects absolute or cwd-relative path)
    dockerfile_path = Path(context) / dockerfile if not Path(dockerfile).is_absolute() else Path(dockerfile)

    # Build command as list
    cmd = ["podman", "build", "-t", image, "-f", str(dockerfile_path)]
    cmd_display = ["podman", "build", "-t", image, "-f", str(dockerfile_path)]

    for key, value in args_dict.items():
        cmd += ["--build-arg", f"{key}={value}"]
        # Anonymize sensitive build args in display command
        if any(sensitive in key.lower() for sensitive in ["token", "password"]):
            cmd_display += ["--build-arg", f"{key}=***"]
        else:
            cmd_display += ["--build-arg", f"{key}={value}"]

    # Handle secrets
    secrets = config.get("secrets", {})
    for secret_item in secrets_list:
        # Resolved config has dicts like {"source": "pypi_password"}
        secret_name = (
            secret_item.get("source") if isinstance(secret_item, dict) else secret_item
        )
        secret_config = secrets.get(secret_name, {})
        env_var = secret_config.get("environment")
        if env_var:
            value = os.environ.get(env_var, "")
            cmd += ["--secret", f"id={secret_name},env={env_var}"]
            cmd_display += ["--secret", f"id={secret_name},env={env_var}"]

    cmd.append(context)
    cmd_display.append(context)

    print(f"🔧 Building image '{image}' with Dockerfile '{dockerfile}'")
    print("👉 Command:", " ".join(cmd_display))

    if not args.dry_run:
        subprocess.run(cmd, check=True)

        # Tag without localhost/ prefix for docker-compose compatibility
        if image.startswith("localhost/"):
            alt_tag = image[len("localhost/") :]
            print(f"🏷️  Tagging as '{alt_tag}' for docker-compose compatibility")
            subprocess.run(["podman", "tag", image, alt_tag], check=True)


if __name__ == "__main__":
    main()
