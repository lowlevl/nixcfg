{...}: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:lowlevl/nixcfg";
    flags = ["--refresh" "--print-build-logs"];
    upgrade = false;

    dates = "02:00";
    randomizedDelaySec = "45min";

    runGarbageCollection = true;
  };
}
