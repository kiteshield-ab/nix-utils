{
  lib,
  fetchFromGitHub,
  rustPlatform,
  writeText,
}:

let
  forkOwner = "embassy-rs";
  rev = "6651cd0877390fdd3c76af037244e795bb867daa";
in
rustPlatform.buildRustPackage rec {
  pname = "chiptool";
  version = "${forkOwner}-${rev}";

  src = fetchFromGitHub {
    owner = forkOwner;
    repo = pname;
    rev = "${rev}";
    hash = "sha256-l5a184UCqy/IeQ25hR43uWoSUg1cexLX2Dxd7mgOHKQ=";
  };

  patches = [
    # Patch-in the revision, there is no .git directory in src that the build-script could use
    (writeText "chiptool-nix-generated-revision.patch" ''
      --- a/src/generate/mod.rs
      +++ b/src/generate/mod.rs
      @@ -136,7 +136,7 @@ pub fn render(ir: &IR, opts: &Options) -> Result<TokenStream> {
           root.items = TokenStream::new(); // Remove default contents
       
           let commit_info = {
      -        let tmp = include_str!(concat!(env!("OUT_DIR"), "/commit-info.txt"));
      +        let tmp = " (${rev} from github:kiteshield-ab/nix-utils#chiptool)";
       
               if tmp.is_empty() {
                   " (untracked)"

    '')
  ];

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
