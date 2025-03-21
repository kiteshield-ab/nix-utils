{
  description = "Kite Shield AB // Nix packaged dev-utilities";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    inputs@{ self, ... }:
    let
      system = "x86_64-linux";
      nixpkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          self.overlays.libsigrok-dreamsourcelab-fw
        ];
      };
      inherit (nixpkgs) pkgs;
    in
    {
      formatter.${system} = pkgs.nixfmt-rfc-style;
      packages.${system} = with pkgs; {
        # Embedded development miscellaneous applications
        arm-compiler = callPackage ./packages/arm-compiler.nix { };
        linkserver = callPackage ./packages/linkserver.nix { };
        mcuxpresso-config-tools = callPackage ./packages/mcuxpresso-config-tools.nix { };
        mcuxpresso-ide = callPackage ./packages/mcuxpresso-ide.nix { };
        # Rust utilities
        form = callPackage ./packages/form.nix { };
        mdbook-wavedrom = callPackage ./packages/mdbook-wavedrom.nix { };
      };
      overlays = {
        # Overlay for libsigrok library containing extra firmware
        libsigrok-dreamsourcelab-fw = import ./overlays/libsigrok-dreamsourcelab-fw.nix;
      };
    };
}
