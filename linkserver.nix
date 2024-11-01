{
  lib,
  pkgs,
  stdenv,
  requireFile,
  ...
}:
let
  filename = "LinkServer_${version}.x86_64.deb";
  version = "24.9.75";
in
stdenv.mkDerivation rec {
  pname = "linkserver";
  inherit version;
  dontUnpack = true;
  src = requireFile {
    url = "https://www.nxp.com/design/design-center/software/development-software/mcuxpresso-software-and-tools-/linkserver-for-microcontrollers:LINKERSERVER";
    name = "${filename}.bin";
    sha256 = "173jjmxv6p45n4484v3r6f93jjsmr840h179pwrffjfbxgpkyiph";
  };
  nativeBuildInputs = with pkgs; [
    makeWrapper
    libarchive
  ];
  # Q: I guess `buildInputs` can be skipped if I just refer to ${pkgs} in the scripts?
  installPhase = ''
    WORK_DIR=work_dir
    sh $src --noexec --keep --target $WORK_DIR && \
    bsdtar -x -f $WORK_DIR/${filename} -C $WORK_DIR && \
    bsdtar -x -f $WORK_DIR/data.tar.gz -C $WORK_DIR && \
    mkdir -p $out/bin && \
    cp -r $WORK_DIR/lib $out && \
    cp -r $WORK_DIR/usr $out && \
    makeWrapper $out/usr/local/LinkServer_${version}/LinkServer $out/bin/${pname} \
      --prefix PATH : ${pkgs.usbutils}/bin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([ pkgs.xorg.libxcb ])}
  '';
  fixupPhase =
    let
      libPath =
        with pkgs;
        lib.makeLibraryPath [
          systemd
          libz
          libusb1
          stdenv.cc.cc.lib
        ];
    in
    ''
      patchelf --debug \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $out/usr/local/LinkServer_${version}/LinkServer \
        $out/usr/local/LinkServer_${version}/dist/LinkServer \
        $out/usr/local/LinkServer_${version}/binaries/redlinkserv \
        $out/usr/local/LinkServer_${version}/binaries/crt_emu_cm_redlink
    '';
}
