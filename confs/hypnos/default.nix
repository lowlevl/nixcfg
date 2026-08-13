{...}: {
  imports = [];

  networking.hostName = "hypnos";
  networking.domain = "local";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05"; # Did you read the comment !?
}
