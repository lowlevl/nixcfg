{
  description = "The various Nix crimes that make my Infrastructure work.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  #> `flake-parts` is automagically included with magics of the flake-registry.
  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    disko,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        nixosModules = import ./mods;

        # In Greek mythology, Hypnos (/ˈhɪpnɒs/; Ancient Greek: Ὕπνος),
        # also spelled Hypnus, is the personification of sleep.
        nixosConfigurations.hypnos = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [./confs/hypnos];

          # FIXME: remove this
          system = "x86_64-linux";
        };
      };

      systems = ["x86_64-linux"];
      perSystem = {pkgs, ...}: {formatter = pkgs.alejandra;};
    };
}
