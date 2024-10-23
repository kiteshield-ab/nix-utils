{
  lib,
  pkgs,
  stdenv,
  makeselfBinFile,
  version,
}:
stdenv.mkDerivation rec {
  pname = "linkserver";
  inherit version;
  src = ./.;
  nativeBuildInputs = with pkgs; [
    libarchive
  ];
  buildInputs = with pkgs; [
    # Q: does it have to be repeated? Not sure what is enough when defining dependencies
    usbutils # `lsusb` command
    systemd
    libusb1
    libz
    stdenv.cc.cc.lib
  ];
  # Q: is there some built-in way to create wrapper scripts that puts deps in path?
  installPhase = ''
    WORK_DIR=linkserver
    mkdir -p $WORK_DIR && \
    cp ${makeselfBinFile} LinkServer.deb.bin && \
    chmod +x LinkServer.deb.bin && \
    ./LinkServer.deb.bin --noexec --keep --target $WORK_DIR && \
    bsdtar -x -f $WORK_DIR/LinkServer_${version}.x86_64.deb -C $WORK_DIR && \
    bsdtar -x -f $WORK_DIR/data.tar.gz -C $WORK_DIR && \
    mkdir -p $out/bin && \
    cp -r $WORK_DIR/lib $out && \
    cp -r $WORK_DIR/usr $out && \
    echo "#!/usr/bin/env bash" >> $out/bin/${pname} && \
    echo "PATH=${pkgs.usbutils}/bin:\$PATH" >> $out/bin/${pname} && \
    echo "exec $out/usr/local/LinkServer_${version}/LinkServer \$@" >> $out/bin/${pname} && \
    chmod 755 $out/bin/${pname}
  '';
  fixupPhase = let
    libPath = with pkgs;
      lib.makeLibraryPath [
        systemd
        libz
        libusb1
        stdenv.cc.cc.lib
      ];
  in ''
    patchelf --debug \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/usr/local/LinkServer_${version}/LinkServer \
      $out/usr/local/LinkServer_${version}/dist/LinkServer \
      $out/usr/local/LinkServer_${version}/binaries/redlinkserv \
      $out/usr/local/LinkServer_${version}/binaries/crt_emu_cm_redlink
  '';
  # Candidates for ELF-patching ?? :^)
  # $out/usr/local/LinkServer_${version}/binaries/blhost
  # $out/usr/local/LinkServer_${version}/binaries/cmtool_cm_redlink
  # $out/usr/local/LinkServer_${version}/binaries/rltool
}
