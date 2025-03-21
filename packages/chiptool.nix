{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

let
  forkOwner = "kiteshield-ab";
  tagInFork = "2025-03-12";
in
rustPlatform.buildRustPackage rec {
  pname = "chiptool";
  version = "${forkOwner}-${tagInFork}";

  src = fetchFromGitHub {
    owner = forkOwner;
    repo = pname;
    rev = "refs/tags/${tagInFork}";
    hash = "sha256-wip0SoN872DIMnl7TONnTHYzPe3JI1N1BjykJCmA9Mc=";
  };

  # Nix's Rust platform does not support git dependencies in lock files.
  # Replace `cargoHash`, copy the lockfile over and provide hashes for git dependencies.
  # https://github.com/NixOS/nixpkgs/blob/a84ebe20c6bc2ecbcfb000a50776219f48d134cc/doc/languages-frameworks/rust.section.md#importing-a-cargolock-file-importing-a-cargolock-file
  cargoLock = {
    lockFile = ./chiptool/Cargo.lock;
    outputHashes = {
      "svd-parser-0.14.7" = "sha256-NQfLXojKqmug/CnJFwPvMXPNGEcWmHKG62XJ+wgyzro=";
    };
  };

  meta = with lib; {
    description = "SVD to PAC next-gen code generator (${forkOwner} fork)";
    mainProgram = "chiptool";
    homepage = "https://github.com/embassy-rs/chiptool";
    license = licenses.mit; # or Apache
  };
}
