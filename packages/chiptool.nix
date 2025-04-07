{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

let
  forkOwner = "embassy-rs";
  rev = "d771c7bd86e0da146a942150aa6d2901dac6399b";
in
rustPlatform.buildRustPackage rec {
  pname = "chiptool";
  version = "${forkOwner}-${rev}";

  src = fetchFromGitHub {
    owner = forkOwner;
    repo = pname;
    rev = "${rev}";
    hash = "sha256-vcU6VNkKTeKP3cNSHxTg1/CA1ua1OuNlkzcNEttFGxw=";
  };

  # Nix's Rust platform does not support git dependencies in lock files.
  # Replace `cargoHash`, copy the lockfile over and provide hashes for git dependencies.
  # https://github.com/NixOS/nixpkgs/blob/a84ebe20c6bc2ecbcfb000a50776219f48d134cc/doc/languages-frameworks/rust.section.md#importing-a-cargolock-file-importing-a-cargolock-file
  cargoLock = {
    lockFile = ./chiptool/Cargo.lock;
    outputHashes = {
      "svd-parser-0.14.5" = "sha256-r78UZfulqPBegBc5/fOkgGGtv5AN2FjZFVg7g8ii5Qc=";
    };
  };

  meta = with lib; {
    description = "SVD to PAC next-gen code generator (${forkOwner} fork)";
    mainProgram = "chiptool";
    homepage = "https://github.com/embassy-rs/chiptool";
    license = licenses.mit; # or Apache
  };
}
