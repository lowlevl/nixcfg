{config, ...}: {
  #> redirect data to `/data` partition using bindfs
  systemd.tmpfiles.settings."10-syncthing" = {
    "/data/syncthing"."d" = {
      user = config.systemd.services.syncthing.serviceConfig.User;
      group = config.systemd.services.syncthing.serviceConfig.Group;
    };
  };
  fileSystems."${config.services.syncthing.dataDir}" = {
    device = "/data/syncthing";

    fsType = "none";
    options = ["bind"];
  };
  systemd.services.syncthing.unitConfig.RequiresMountsFor = config.services.syncthing.dataDir;

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;

    settings = {
      options.urAccepted = -1;

      defaults.folder.path = "~"; # manually fixed in UI, awaiting upstream
      devices."hive" = {
        autoAcceptFolders = true;
        id = "3HPRDTR-PCQYQII-U75J7MQ-DGN7UFE-K7JE5RC-KUHFYWC-WTRZTKP-DUXJPQJ";
      };
    };
  };
}
