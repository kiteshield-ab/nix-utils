{
  description = "LinkServer package";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    linkserver.url = "github:kiteshield-ab/linkserver-nix";
    linkserver.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    linkserver,
  }: let
    # FIX THIS:
    makeselfBinFile = ./placholder/path/to/LinkServer_1.6.133.x86_64.deb.bin;
    # FIX THIS:
    version = "1.6.133";

    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter.${system} = pkgs.alejandra;
    defaultPackage.${system} =
      linkserver.lib.mkLinkServerDerivation
      {
        inherit makeselfBinFile version;
      };
  };
}
