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
      packages.${system} = {
        sigrok-cli = pkgs.sigrok-cli;
        arm-compiler = pkgs.callPackage ./packages/arm-compiler.nix { };
        linkserver = pkgs.callPackage ./packages/linkserver.nix { };
        mcuxpresso-config-tools = pkgs.callPackage ./packages/mcuxpresso-config-tools.nix { };
        mcuxpresso-ide = pkgs.callPackage ./packages/mcuxpresso-ide.nix { };
      };
      overlays = {
        libsigrok-dreamsourcelab-fw = import ./overlays/libsigrok-dreamsourcelab-fw.nix;
      };
    };
}
