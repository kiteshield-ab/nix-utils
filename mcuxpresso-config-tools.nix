{
  lib,
  pkgs,
  stdenv,
  requireFile,
  glib-networking,
  jdk17,
  glib,
  libXtst,
  libsecret,
  ...
}:
let
  filename = "mcuxpresso-config-tools-${version}_amd64.deb";
  partialVersion = "v16.1";
  version = "${partialVersion}-1";
  binNxpPrefix = "$out/opt/nxp/MCUX_CFG_${partialVersion}";
in
stdenv.mkDerivation rec {
  pname = "mcuxpresso-config-tools";
  inherit version;
  dontUnpack = true;
  src = requireFile {
    url = "https://www.nxp.com/design/software/development-software/mcuxpresso-config-tools-pins-clocks-and-peripherals:MCUXpresso-Config-Tools";
    name = "${filename}.bin";
    sha256 = "14kq575y8waxy5q5kl5j3i3ncwy44x2l7vysdd7qs1i0iaq8ypf2";
  };
  nativeBuildInputs = with pkgs; [
    makeWrapper
    libarchive
  ];
  installPhase =
  ''
    WORK_DIR=work_dir
    sh $src --noexec --keep --target $WORK_DIR && \
    bsdtar -x -f $WORK_DIR/${filename} -C $WORK_DIR && \
    bsdtar -x -f $WORK_DIR/data.tar.gz -C $WORK_DIR && \
    mkdir -p $out/bin && \
    cp -r $WORK_DIR/opt $out && \
    rm -rf ${binNxpPrefix}/bin/jre && \
    cp -r $WORK_DIR/usr $out && \
    makeWrapper ${binNxpPrefix}/bin/tools $out/bin/${pname} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          [
            glib
            libXtst
            libsecret
          ]
        )
      } \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --add-flags "-configuration \$HOME/.eclipse/''${pname}_${version}/configuration"
  '';
  fixupPhase = ''
    patchelf --debug \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      ${binNxpPrefix}/bin/tools && \
    cp ${binNxpPrefix}/bin/tools.ini tools.ini.copy && \
    echo -e "-vm" > ${binNxpPrefix}/bin/tools.ini && \
    echo -e "${jdk17}/bin/java" >> ${binNxpPrefix}/bin/tools.ini && \
    cat tools.ini.copy >> ${binNxpPrefix}/bin/tools.ini
  '';
}
