{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "form";
  version = "0.12.1";

  useFetchCargoVendor = true;
  src = fetchCrate {
    inherit pname version;
    hash = "sha256-QwiYNmL5oncCw5oEygueyaaudBhydbtYhlpX+hA25zc=";
  };
  cargoHash = "sha256-DQSu4UhDF/Lxj12/vjZ6bCPyZpeceL9+5c/s9Gtou08=";

  meta = with lib; {
    description = "A small script to move inline modules into the proper directory structure";
    mainProgram = "form";
    homepage = "https://github.com/djmcgill/form";
    changelog = "https://github.com/djmcgill/form/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
  };
}
