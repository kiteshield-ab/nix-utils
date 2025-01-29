{
  fontconfig,
  freetype,
  glib,
  glib-networking,
  gsettings-desktop-schemas,
  gtk3,
  jdk,
  jdk17,
  lib,
  libsecret,
  libX11,
  libXrender,
  libXtst,
  pkgs,
  requireFile,
  stdenv,
  zlib,
  ...
}:
let
  filename = "mcuxpressoide-${version}.x86_64.deb";
  version = "24.12.148";
  binNxpPrefix = "$out/usr/local/mcuxpressoide-24.12.148/ide";
  execName = "mcuxpressoide";
in
stdenv.mkDerivation rec {
  pname = "mcuxpresso-ide";
  inherit version;
  dontUnpack = true;
  src = requireFile {
    url = "TODO";
    name = "${filename}.bin";
    sha256 = "1mcfql3w3m3ja641nn7h3igvz8ls3paq491brkfp9lnrd4w1df9l";
  };
  nativeBuildInputs = with pkgs; [
    makeWrapper
    libarchive
  ];
  buildInputs = [
    fontconfig
    freetype
    gsettings-desktop-schemas
    gtk3
    jdk17
    libX11
    libXrender
    zlib
  ];
  installPhase = ''
    WORK_DIR=work_dir
    sh $src --noexec --keep --target $WORK_DIR && \
    bsdtar -x -f $WORK_DIR/${filename} -C $WORK_DIR && \
    bsdtar -x -f $WORK_DIR/data.tar.gz -C $WORK_DIR && \
    mkdir -p $out/bin && \
    cp -r $WORK_DIR/usr $out && \
    makeWrapper ${binNxpPrefix}/${execName} $out/bin/${pname} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath ([
          glib
          libXtst
          libsecret
        ])
      } \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --add-flags "-configuration \$HOME/.eclipse/''${pname}_${version}/configuration"
  '';
  fixupPhase = ''
    patchelf --debug \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      ${binNxpPrefix}/${execName} && \
    sed -i '/^-vm$/,+1d' ${binNxpPrefix}/${execName}.ini && \
    cp ${binNxpPrefix}/${execName}.ini ${execName}.ini.copy && \
    echo -e "-vm" > ${binNxpPrefix}/${execName}.ini && \
    echo -e "${jdk17}/bin/java" >> ${binNxpPrefix}/${execName}.ini && \
    cat ${execName}.ini.copy >> ${binNxpPrefix}/${execName}.ini
  '';
}
