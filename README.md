# LinkServer derivation builder

# External dependencies
- External 'Makeself' binary from the NXP website.

## How to use
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
