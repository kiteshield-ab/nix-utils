{
  description = "Kite Shield AB // Nix packaged dev-utilities";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    inputs@{ self, ... }:
    let
      system = "x86_64-linux";
      nixpkgs = import inputs.nixpkgs { inherit system; };
      inherit (nixpkgs) pkgs;
    in
    {
      formatter.${system} = pkgs.nixfmt-rfc-style;
      packages.${system} = {
        linkserver = pkgs.callPackage ./packages/linkserver.nix { };
        mcuxpresso-config-tools = pkgs.callPackage ./packages/mcuxpresso-config-tools.nix { };
      };
    };
}
