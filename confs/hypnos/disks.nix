{...}: {
  #> enable periodic fsTRIM on SSDs
  services.fstrim.enable = true;

  disko.devices = {
    #> root device with ESP & `/`
    disk.nvme0 = {
      type = "disk";
      content = {
        type = "gpt";

        partitions.ESP = {
          type = "EF02";
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["umask=0077"];
          };
        };

        partitions.root = {
          size = "100%";
          content = {
            type = "luks";
            name = "lroot";
            settings.allowDiscards = true;

            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/";
            };
          };
        };
      };
    };

    #> data storage
    disk.sata0 = {
      type = "disk";
      content = {
        type = "gpt";

        partitions.data = {
          size = "100%";
          content = {
            type = "luks";
            name = "ldata";
            settings.allowDiscards = true;

            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/data";
            };
          };
        };
      };
    };
  };
}
