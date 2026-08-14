{...}: {
  #> setup a 16 GiB swapfile
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];

  #> enable `zswap` kernel management
  boot.zswap.enable = true;
}
