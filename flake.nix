{
  description = "The various Nix crimes that make my Infrastructure work.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    disko.url = "github:nix-community/disko";
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
        # In Greek mythology, Hypnos (/ˈhɪpnɒs/; Ancient Greek: Ὕπνος),
        # also spelled Hypnus, is the personification of sleep.
        nixosConfigurations.hypnos = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [./confs/hypnos];
        };
      };

      systems = ["x86_64-linux"];
      perSystem = {...}: {};
    };
}
