{inputs, ...}: {
  imports = [inputs.sops-nix.nixosModules.default];

  sops.defaultSopsFile = ../secrets.yaml;
}
