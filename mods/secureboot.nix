{inputs, ...}: {
  imports = [inputs.lanzaboote.nixosModules.default];

  boot.loader.efi.canTouchEfiVariables = true;

  #> fully automatic generation & enrollment of SecureBoot keys
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";

    autoGenerateKeys.enable = true;
    autoEnrollKeys = {
      enable = true;
      autoReboot = true;
    };
  };
}
