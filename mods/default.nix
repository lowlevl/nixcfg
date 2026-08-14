{
  #> system configuration
  secureboot = import ./secureboot.nix;
  unluks = import ./unluks.nix;
  zswap = import ./zswap.nix;
  nix = import ./nix.nix;

  #> base services & configuration
  fw = import ./fw.nix;
  sshd = import ./sshd.nix;
  users = import ./users.nix;
  locale = import ./locale.nix;

  #> monitoring & resillience
  alerts = import ./alerts.nix;
}
