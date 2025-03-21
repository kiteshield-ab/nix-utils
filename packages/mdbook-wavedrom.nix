{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-wavedrom";
  version = "0.10.0";

  useFetchCargoVendor = true;
  src = fetchCrate {
    inherit pname version;
    hash = "sha256-eGFDZQ71ofXeulsGdK6T8QUpgtEGbpqKIrbYKtFlUD0=";
  };
  cargoHash = "sha256-EExr5acmka37i5LYqjhERSRRAbSKGrndjsX+6wfnEXI=";

  cargoPatches = [
    # Lockfile points to the `mdbook 0.4.15` that does not build.
    # Bumping the lockfile in order to be able to build a crate.
    ./mdbook-wavedrom/bump-the-lockfile.patch
  ];

  meta = with lib; {
    description = "mdbook preprocessor to add wavedrom support";
    mainProgram = "mdbook-wavedrom";
    homepage = "https://github.com/JasMoH/mdbook-wavedrom";
    changelog = "https://github.com/JasMoH/mdbook-wavedrom/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
  };
}
