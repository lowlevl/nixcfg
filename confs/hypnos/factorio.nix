{
  pkgs,
  lib,
  ...
}: {
  #> allow factorio as an unfree package
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) ["factorio-headless"];

  #> redirect data to `/data` partition using bindfs
  systemd.tmpfiles.settings."10-factorio" = {
    "/data/blind/factorio"."d" = {};
  };
  fileSystems."/var/lib/private/factorio" = {
    device = "/data/blind/factorio";

    fsType = "none";
    options = ["bind"];
  };
  systemd.services.factorio.unitConfig.RequiresMountsFor = "/var/lib/private/factorio";

  services.factorio = {
    enable = true;
    openFirewall = true;

    package = pkgs.factorio-headless.override {
      # NOTE: this can simply be migrated to `versions` in the next NixOS release
      versionsJson = pkgs.writers.writeJSON "versions.json" {
        x86_64-linux.headless.stable = rec {
          version = "2.1.24";
          sha256 = "sha256-xJtmz/kKzv+Hsw8pc68N9/UXEssu4xU+AWnZvtRqlk8=";

          needsAuth = false;
          url = "https://factorio.com/get-download/${version}/headless/linux64";
          name = "factorio_headless_x64-${version}.tar.xz";
          tarDirectory = "x64";
        };
      };
    };

    lan = true;
    autosave-interval = 3;
    nonBlockingSaving = true;

    game-name = "A better world";
    description = "A game where we try to engineer a better world out of this one";

    allowedPlayers = ["mayabeille" "Reliant_Gesture"];
    admins = ["mayabeille"];
  };
}
