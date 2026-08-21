{config, ...}: {
  services.openssh = {
    enable = true;

    ports = [223];
    openFirewall = true;
    startWhenNeeded = !config.services.fail2ban.enable; #< conflicts with fail2ban

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services.fail2ban.jails = {
    sshd.settings = {
      backend = "systemd";
      mode = "aggressive";
    };
  };
}
