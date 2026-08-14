{inputs, ...}: {
  nix = {
    #> enable flakes
    settings.experimental-features = ["nix-command" "flakes"];

    #> automatic store optimization
    optimise = {
      automatic = true;
      dates = ["03:45"];
    };

    #> automatic garbage-collect
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    #> propagate flake inputs to older nix features
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [
      "nixpkgs=flake:nixpkgs"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
}
