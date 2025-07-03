{
  description = "Kite Shield AB // Nix packaged dev-utilities";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      # forAllSystems follows this guide:
      # https://github.com/Misterio77/nix-starter-configs/issues/64#issuecomment-1941420712
      pkgsFor = system: {
        inherit system;

        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            self.overlays.libsigrok-dreamsourcelab-fw
          ];
        };
      };

      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f (pkgsFor system));
    in
    {
      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixfmt-tree);
      packages = forAllSystems (
        { pkgs, ... }:
        with pkgs;
        {
          # Embedded development miscellaneous applications
          arm-compiler = callPackage ./packages/arm-compiler.nix { };
          linkserver = callPackage ./packages/linkserver.nix { };
          mcuxpresso-config-tools = callPackage ./packages/mcuxpresso-config-tools.nix { };
          mcuxpresso-ide = callPackage ./packages/mcuxpresso-ide.nix { };
          # Rust utilities
          chiptool = callPackage ./packages/chiptool.nix { };
          form = callPackage ./packages/form.nix { };
          mdbook-wavedrom = callPackage ./packages/mdbook-wavedrom.nix { };
        }
      );
      overlays = {
        # Overlay for libsigrok library containing extra firmware
        libsigrok-dreamsourcelab-fw = import ./overlays/libsigrok-dreamsourcelab-fw.nix;
      };
    };
}
