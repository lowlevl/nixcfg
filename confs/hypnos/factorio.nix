{lib, ...}: {
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

    lan = true;
    autosave-interval = 3;
    nonBlockingSaving = true;

    game-name = "A better world";
    description = "A game where we try to engineer a better world out of this one";

    allowedPlayers = ["mayabeille" "Reliant_Gesture"];
    admins = ["mayabeille"];
  };
}
