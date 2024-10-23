{
  description = "LinkServer derivation builder";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs @ {self, ...}: let
    system = "x86_64-linux";
    nixpkgs = import inputs.nixpkgs {inherit system;};
    inherit (nixpkgs) pkgs;
  in {
    formatter.${system} = pkgs.alejandra;
    lib.mkLinkServerDerivation = {
      makeselfBinFile,
      version,
    }:
      pkgs.callPackage ./linkserver.nix {inherit makeselfBinFile version;};
    defaultTemplate = {
      path = ./template;
      description = "Flake based nix package with placeholders";
    };
  };
}
