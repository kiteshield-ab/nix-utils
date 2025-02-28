{
  lib,
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
let
  licensedExecutables = [
    "armasm"
    "armclang"
    "armlink"
    "fromelf"
  ];
  licencelessExecutables = [
    "armar"
    "armlm"
    "armlm-ipc"
  ];
  # bash is pain
  listToBashArray = (l: ("(" + (lib.strings.concatMapStringsSep " " (v: "\"${v}\"") l) + ")"));
  _wrappedExecutables = listToBashArray licensedExecutables;
  _patchedExecutables = listToBashArray (licensedExecutables ++ licencelessExecutables);
in
stdenv.mkDerivation rec {
  pname = "arm-compiler";
  version = "6.23";
  dontUnpack = true;
  src = fetchurl {
    url = "https://artifacts.tools.arm.com/arm-compiler/6.23/32/standalone-linux-x86_64-rel.tar.gz";
    hash = "sha256-SLLwKsiUHcrJelp5K13byc783nuVo5toHuE/mzIf/+g=";
  };
  nativeBuildInputs = with pkgs; [
    makeWrapper
    libarchive
  ];
  installPhase = ''
    src_unpacked=src_unpacked
    executables=${_wrappedExecutables}

    mkdir $src_unpacked && \
    bsdtar -x -f $src -C $src_unpacked && \
    mkdir -p $out && \
    mv $src_unpacked/bin $out/_bin && \
    mv $src_unpacked/* $out && \
    mkdir $out/bin

    for executable in "''${executables[@]}"
    do
        cat <<EOF > "$out/bin/$executable"
    #!/usr/bin/env bash
    # Try to defensively activate the non-commercial version of arm-compiler.
    # This will create a license file cached in "$HOME/.armlm" directory.
    # Should be more-less a noop if activated already :TM:
    #
    $out/_bin/armlm activate --server https://mdk-preview.keil.arm.com --product KEMDK-COM0 &> /dev/null
    eval $out/_bin/$executable \$@
    EOF
        chmod 755 "$out/bin/$executable" || exit 1
    done
  '';
  fixupPhase = ''
    executables=${_patchedExecutables};
    for executable in "''${executables[@]}"
    do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$out/_bin/$executable" || exit 1
    done
  '';
}
