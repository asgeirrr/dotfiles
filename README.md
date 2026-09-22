# dotfiles
Treasured Linux home directory settings such as .vimrc or .gitconfig.

This is primarily for my personal purposes to be able to setup my development environment quickly.

The configuration is managed by a standalone [Home Manager](https://github.com/nix-community/home-manager)
Nix flake. System services, drivers, GnuPG, smartcard support, Podman, and other hardware-facing
packages remain managed by the host distribution.

Apply the configuration with:

```sh
nix run .#home-manager -- switch --flake .
```

This also registers the repository as Home Manager's default flake. Subsequent changes can be applied with
`home-manager switch`.

Update pinned dependencies with `nix flake update`, review the result, and apply the configuration again.
