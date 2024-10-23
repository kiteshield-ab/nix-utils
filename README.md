# LinkServer derivation builder

# External dependencies
- External 'Makeself' binary from the NXP website.

## How to use (system wide with udev rules)
1. Add an input to your system flake

```nix
  inputs = {
    linkserver = {
      url = "github:kiteshield-ab/linkserver-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
```

2. Build the derivation, optionally populate udev rules

```nix
let
  inherit (inputs.linkserver.lib) mkLinkServerDerivation;
  linkServerMakeselfFile = ./path-to-the-bin/LinkServer_1.6.133.x86_64.deb.bin;
  linkServerDerivation = mkLinkServerDerivation {
      # Path to the makeself installer
      makeselfBinFile = linkServerMakeselfFile;
      # Version must match one from the provided installer.
      # Internal paths depend on it.
      version = "1.6.133";
  };
in
{
  # Populate udev rules
  services.udev.packages = [linkServerDerivation];
  # Install globally
  environment.systemPackages = [linkServerDerivation];
}
```

## How to use (from template)

Run
```sh
$ nix flake new <path> -t github:kiteshield-ab/linkserver-nix
```
and fix variables marked with `FIX THIS` comment.

Now you can run `nix shell` or `nix run` and have linkserver available.

Note: this approach does not take care of udev rules. MCU-Link works though if one uses eg. https://github.com/jneem/probe-rs-rules
