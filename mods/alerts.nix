{
  config,
  pkgs,
  lib,
  ...
}: let
  recipient = "hello" + "@" + "unw" + "." + "re";
in {
  # FIXME: make the module configurable and reusable
  # FIXME: attach to all systemd units
  # FIXME: adapt confinement policy

  systemd.services."alerts@" = {
    enable = true;
    enableStrictShellChecks = true;

    description = "A facility to send mails for failed units";
    onFailure = lib.mkForce []; #< prevent circular triggers

    confinement.enable = true;
    serviceConfig = {
      Type = "oneshot";

      DynamicUser = true;
      User = "alerts";
      Group = "alerts";

      CapabilityBoundingSet = [""];
      LockPersonality = true;

      ProtectProc = "invisible";
      ProtectClock = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      RestrictNamespaces = true;
      RestrictAddressFamilies = ["AF_INET" "AF_INET6"];

      ExecStartPre = "+systemctl status --full '%i' > %t/unit.log";
    };

    script = ''
      ${lib.getExe pkgs.msmtp} --read-recipients --read-envelope-from <<EOF
      From: alerts@${config.networking.fqdn}
      To: ${recipient}
      Subject: systemd Unit "$1" failed

      This is your systemd monitor,
      it seems like Unit "$1" failed; see:

      $(cat "$2"/unit.log)

      --
      Sincerely,
      Beep boop.

      EOF
    '';
    scriptArgs = "%i %t";
  };
}
