{...}: {
  networking = {
    firewall.enable = true;
    nftables.enable = true;
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;

    ignoreIP = [
      "10.0.0.0/8"
    ];

    bantime = "1h";
    bantime-increment.enable = true;
  };
}
