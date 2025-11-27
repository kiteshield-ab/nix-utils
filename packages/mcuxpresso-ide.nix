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
  version = "25.6.136";
  binNxpPrefix = "$out/usr/local/mcuxpressoide-25.6.136/ide";
  execName = "mcuxpressoide";
in
stdenv.mkDerivation rec {
  pname = "mcuxpresso-ide";
  inherit version;
  dontUnpack = true;
  src = requireFile {
    url = "https://www.nxp.com/design/design-center/software/development-software/mcuxpresso-software-and-tools-/mcuxpresso-integrated-development-environment-ide:MCUXpresso-IDE";
    name = "${filename}.bin";
    sha256 = "0sjrg0shcjyps3hri77c3id0k1iqkcgp5h8hkv7ssnnq56gcnl8g";
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
