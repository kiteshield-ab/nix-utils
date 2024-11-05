# Based on
# https://sigrok.org/gitweb/?p=sigrok-util.git;a=blob;f=firmware/dreamsourcelab-dslogic/sigrok-fwextract-dreamsourcelab-dslogic;h=4e357f31087347365ab3afebf0bb254b8ec01d89;hb=69747ca48b3d17ac7532439e487b9ba829828cfd
let
  dsView = fetchTarball {
    url = "https://github.com/DreamSourceLab/DSView/archive/886b847c21c606df3138ce7ad8f8e8c363ee758b.zip";
    sha256 = "0hjm9vg9m2a5y5963w6vkw6q27cjn5nssigshckc81ygig8rxsfv";
  };
in
final: prev: {
  libsigrok = prev.libsigrok.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        cp ${dsView}/DSView/res/DSLogic50.bin $out/share/sigrok-firmware/dreamsourcelab-dslogic-fpga-5v.fw
        cp ${dsView}/DSView/res/DSLogic33.bin $out/share/sigrok-firmware/dreamsourcelab-dslogic-fpga-3v3.fw
        cp ${dsView}/DSView/res/DSLogic.fw $out/share/sigrok-firmware/dreamsourcelab-dslogic-fx2.fw
        cp ${dsView}/DSView/res/DSCope.bin $out/share/sigrok-firmware/dreamsourcelab-dscope-fpga.fw
        cp ${dsView}/DSView/res/DSCope.fw $out/share/sigrok-firmware/dreamsourcelab-dscope-fx2.fw
        cp ${dsView}/DSView/res/DSLogicPro.bin $out/share/sigrok-firmware/dreamsourcelab-dslogic-pro-fpga.fw
        cp ${dsView}/DSView/res/DSLogicPro.fw $out/share/sigrok-firmware/dreamsourcelab-dslogic-pro-fx2.fw
        cp ${dsView}/DSView/res/DSLogicPlus.bin $out/share/sigrok-firmware/dreamsourcelab-dslogic-plus-fpga.fw
        cp ${dsView}/DSView/res/DSLogicPlus.fw $out/share/sigrok-firmware/dreamsourcelab-dslogic-plus-fx2.fw
        cp ${dsView}/DSView/res/DSLogicBasic.bin $out/share/sigrok-firmware/dreamsourcelab-dslogic-basic-fpga.fw
        cp ${dsView}/DSView/res/DSLogicBasic.fw $out/share/sigrok-firmware/dreamsourcelab-dslogic-basic-fx2.fw
      '';
  });
}
