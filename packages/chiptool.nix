{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

let
  forkOwner = "embassy-rs";
  rev = "23011236c00a0b97edb2230b9f990b6c1b48a508";
in
rustPlatform.buildRustPackage rec {
  pname = "chiptool";
  version = "${forkOwner}-${rev}";

  src = fetchFromGitHub {
    owner = forkOwner;
    repo = pname;
    rev = "${rev}";
    hash = "sha256-bfxeLOBx9ipcyEg8M7ay1yZlLApnYTLQGf0CFh0r9Pw=";
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
