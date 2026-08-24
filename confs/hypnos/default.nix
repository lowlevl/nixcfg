{inputs, ...}: {
  hardware.facter.reportPath = ./facter.json;

  imports = [
    inputs.disko.nixosModules.default
    ./disks.nix

    inputs.self.nixosModules.secureboot
    inputs.self.nixosModules.unluks
    inputs.self.nixosModules.zswap
    inputs.self.nixosModules.nix

    inputs.self.nixosModules.fw
    inputs.self.nixosModules.sshd
    inputs.self.nixosModules.users
    inputs.self.nixosModules.locale

    inputs.self.nixosModules.alerts
    inputs.self.nixosModules.sops

    ./alerts.nix
    ./backups.nix

    ./caddy.nix
    ./art.nix
  ];

  disko.devices.disk.nvme0.device = "/dev/nvme0n1";
  disko.devices.disk.sata0.device = "/dev/sda";

  networking.hostName = "hypnos";
  networking.domain = "local";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05"; # Did you read the comment !?
}
