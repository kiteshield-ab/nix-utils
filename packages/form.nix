{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "form";
  version = "0.13.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-7+5HEyP7480UM5dydavoiclX3YTvW46V8r+Vpqt4xWk=";
  };
  cargoHash = "sha256-ItNBQKye1GD01KFBubMLxksv8OCWIxya/LlZ9g6Jdg8=";

  meta = with lib; {
    description = "A small script to move inline modules into the proper directory structure";
    mainProgram = "form";
    homepage = "https://github.com/djmcgill/form";
    changelog = "https://github.com/djmcgill/form/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
  };
}
