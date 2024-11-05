# Kite Shield AB // Nix packaged dev-utilities

Either depend on this flake and install packages from it or run directly with `nix run`

Examples:
```sh
nix run github:kiteshield-ab/nix-utils#mcuxpresso-config-tools
```

Packages depend on proprietary software that has to be provisioned manually. Appropriate instructions will pop up when running the command without prerequisite artifacts available.

## Overlays

This package provides an overlay for `libsigrok` which extends it with extra probe firmware.

Flake itself contains an example how to use it and exposes `sigrok-cli` based on it. In order to use different `libsigrok` based programs, depend on this flake in your own flake and enable the overlay (i.e. add `overlays` property when calling `nixpkgs` function and access a `libsigrok` dependent package from its result - basically copy-paste of what this flake is doing internally).
