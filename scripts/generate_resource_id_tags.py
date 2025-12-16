#!/usr/bin/env python3
"""Generate ctags entries for resource_id -> Handle class mappings."""

from __future__ import annotations

import re
import sys
from pathlib import Path


def generate_tags(root: Path) -> list[str]:
    tags = []
    class_pattern = re.compile(r"^class\s+(\w+)")
    resource_id_pattern = re.compile(r'^\s+resource_id\s*=\s*["\']([^"\']+)["\']')

    for py_file in root.rglob("*.py"):
        if "/tests/" in str(py_file):
            continue
        try:
            lines = py_file.read_text().splitlines()
        except Exception:
            continue

        classes: list[tuple[str, int]] = []
        resource_ids: list[tuple[str, int]] = []

        for i, line in enumerate(lines, 1):
            class_match = class_pattern.match(line)
            if class_match:
                classes.append((class_match.group(1), i))

            resource_match = resource_id_pattern.match(line)
            if resource_match:
                resource_ids.append((resource_match.group(1), i))

        # Match each resource_id to the most recent class before it
        for resource_id, res_line in resource_ids:
            for class_name, class_line in reversed(classes):
                if class_line < res_line:
                    abs_path = py_file.resolve()
                    tags.append(f'{resource_id}\t{abs_path}\t{class_line};"\tc')
                    break

    return sorted(tags)


if __name__ == "__main__":
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(".")
    for tag in generate_tags(root):
        print(tag)
