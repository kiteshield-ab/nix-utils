{
  buildEclipse,
  stdenv,
  requireFile,
  jdk17,
  ...
}:
let
  name = "mcuxpressotools";
  version = "v16.1-1";
  description = "MCUXpresso Config Tools";
  filename = "mcuxpresso-config-tools-${version}_amd64.deb";

  src = stdenv.mkDerivation {
    inherit version description;
    name = "${name}-src";
    src = requireFile {
      url = "https://www.nxp.com/design/software/development-software/mcuxpresso-config-tools-pins-clocks-and-peripherals:MCUXpresso-Config-Tools";
      name = "${filename}.bin";
      sha256 = "14kq575y8waxy5q5kl5j3i3ncwy44x2l7vysdd7qs1i0iaq8ypf2";
    };

    buildCommand = ''
      # Unpack tarball.
      mkdir -p deb
      sh $src --target deb || true
      ar -xv deb/${filename}
      tar xfvz data.tar.gz -C .

      mkdir -p ./final/eclipse
      mv ./opt/nxp/MCUX_CFG_v16.1/bin/* ./opt/nxp/MCUX_CFG_v16.1/bin/.* final/eclipse
      mv ./usr final/
      mv final/eclipse/tools final/eclipse/eclipse
      echo -e '-vm\njava' > final/eclipse/eclipse.ini
      cat final/eclipse/tools.ini >> final/eclipse/eclipse.ini

      # Create custom .eclipseproduct file
      echo "name=${name}
      id=com.nxp.${name}
      version=${version}
      " > final/eclipse/.eclipseproduct

      # Additional files
      mkdir -p final/usr/share/mime
      mv ./opt/nxp/MCUX_CFG_v16.1/mcu_data final/mcu_data

      cd ./final
      tar -czf $out ./
    '';
  };
in
buildEclipse {
  inherit description name src;
  jdk = jdk17;
}
