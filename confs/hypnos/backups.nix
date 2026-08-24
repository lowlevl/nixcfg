{config, ...}: {
  sops.secrets."backups/password" = {};

  services.restic.backups.fs = {
    createWrapper = true;

    extraBackupArgs = ["--tag fs"];
    paths = ["/data"];

    rcloneConfig = {
      type = "sftp";
      port = "23";
      host = "u655771.your-storagebox.de";
      user = "u655771";
      key_file = "/etc/ssh/ssh_host_ed25519_key";
      host_keys = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICf9svRenC/PLKIL9nk6K/pxQgoiFC41wTNvoIncOxs
      '';
    };
    repository = "rclone:stor0:~";

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 2"
    ];

    initialize = true;
    passwordFile = config.sops.secrets."backups/password".path;
  };
}
