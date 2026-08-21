{config, ...}: {
  sops.secrets."alerts/password" = {};

  services.alerts = {
    enable = true;

    mta = {
      hostname = "smtp.mail.ovh.net";
      tls = true;

      username = config.services.alerts.sender;
      passwordFile = config.sops.secrets."alerts/password".path;
    };

    sender = "postm" + "aster" + "@u" + "nw.re";
    recipients = [("hel" + "lo@" + "un" + "w.re")];

    on.failure = builtins.attrNames config.systemd.services;
  };
}
