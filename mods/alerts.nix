{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.alerts;
in {
  options.services.alerts = {
    enable = lib.mkEnableOption "A facility to send on alerts about units";

    mta = lib.mkOption {
      description = "Configuration for the sending Mail Transfer Agent";
      type = lib.types.submodule {
        options = {
          hostname = lib.mkOption {
            description = "MTA hostname";
            type = lib.types.str;
          };

          port = lib.mkOption {
            description = "MTA port";
            default =
              if cfg.mta.tls
              then 587
              else 25;
            type = lib.types.int;
          };

          tls = lib.mkOption {
            description = "Whether to connect to the MTA with TLS";
            default = false;
            type = lib.types.bool;
          };

          username = lib.mkOption {
            description = "User to authenticate to the MTA with";
            default = null;
            type = lib.types.nullOr lib.types.str;
          };

          passwordFile = lib.mkOption {
            description = "A file containing the password to authenticate to the MTA";
            default = null;
            type = lib.types.nullOr lib.types.str;
          };
        };
      };
    };

    sender = lib.mkOption {
      description = "The sender of the alerts";
      default = "alerts@${config.networking.fqdn}";
      type = lib.types.str;
    };
    recipients = lib.mkOption {
      description = "A list of recipients of the alerts";
      type = lib.types.listOf lib.types.str;
    };

    on = lib.mkOption {
      default = {};
      type = lib.types.submodule {
        options = {
          failure = lib.mkOption {
            description = "A list of systemd.unit to watch for failure";
            default = [];
            type = lib.types.listOf lib.types.str;
          };

          success = lib.mkOption {
            description = "A list of systemd.unit to watch for success";
            default = [];
            type = lib.types.listOf lib.types.str;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = let
      failures =
        builtins.map
        (service:
          pkgs.writeTextDir "/etc/systemd/system/${service}.service.d/alerts-onfailure.conf" ''
            [Unit]
            OnFailure=alerts@%N.service
          '')
        (builtins.filter (service: service != "alerts@") cfg.on.failure);

      successes =
        builtins.map
        (service:
          pkgs.writeTextDir "/etc/systemd/system/${service}.service.d/alerts-onsuccess.conf" ''
            [Unit]
            OnSuccess=alerts@%N.service
          '')
        (builtins.filter (service: service != "alerts@") cfg.on.success);
    in
      failures ++ successes;

    systemd.services."alerts@" = {
      enable = true;
      enableStrictShellChecks = true;

      description = "Notification sender for {succeeded, failed} units";
      serviceConfig = {
        Type = "oneshot";

        DynamicUser = true;
        User = "alerts";
        Group = "alerts";
        SupplementaryGroups = ["systemd-journal"];

        CapabilityBoundingSet = [""];
        LockPersonality = true;

        ProtectProc = "invisible";
        ProtectClock = true;
        ProtectHostname = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictNamespaces = true;
        #> `AF_UNIX` is required for systemctl
        RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6"];

        ReadOnlyPaths = ["+/"];
        ReadWritePaths = [""];
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        PrivateTmp = true;

        LoadCredential = lib.optional (!isNull cfg.mta.passwordFile) "password:${cfg.mta.passwordFile}";
      };

      script = ''
        status=$(systemctl status --full "$1" || true)

        ${lib.getExe pkgs.curl} \
          --silent --show-error \
          --mail-from="${cfg.sender}" \
          ${lib.concatMapStringsSep " " (rcpt: ''--mail-rcpt="${rcpt}"'') cfg.recipients} \
          ${lib.optionalString (!isNull cfg.mta.username) ''--variable="user=${cfg.mta.username}"''} \
          ${lib.optionalString (!isNull cfg.mta.passwordFile) ''--variable="pass@$2/password"''} \
          ${lib.optionalString (!isNull cfg.mta.username) ''--expand-user="{{user:trim}}:{{pass:trim}}"''} \
          ${lib.optionalString (cfg.mta.tls) "--ssl-reqd"} \
          "smtp://${cfg.mta.hostname}:${toString cfg.mta.port}" \
          --crlf --upload-file - <<EOF
        From: <${cfg.sender}>
        To: ${lib.concatMapStringsSep ", " (rcpt: "<${rcpt}>") cfg.recipients}
        Subject: systemd Unit "$1" status.

        This is your systemd monitor,
        here is the state of Unit "$1":

        $status

        --
        Sincerely,
        Beep boop.

        EOF
      '';
      scriptArgs = "%i %d";
    };
  };
}
