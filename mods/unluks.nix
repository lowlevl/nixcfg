{
  config,
  lib,
  ...
}: {
  boot.initrd = {
    systemd.users.root.shell = "/bin/systemd-tty-ask-password-agent";

    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 222;
        hostKeys = ["/etc/secrets/initrd/ssh_host_ed25519_key"];

        #> this pulls all the keys from `wheel` users
        authorizedKeys = lib.concatLists (
          lib.mapAttrsToList (name: user:
            if lib.elem "wheel" user.extraGroups
            then user.openssh.authorizedKeys.keys
            else [])
          config.users.users
        );
      };
    };
  };
}
