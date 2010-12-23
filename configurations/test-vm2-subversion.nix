{pkgs, ...}:

{
  boot = {
    loader = {
      grub = {
        device = "/dev/sda";
      };
    };
  };

  fileSystems = [
    { mountPoint = "/";
      device = "/dev/sda2";
    }
  ];

  swapDevices = [
    { device = "/dev/sda1"; }
  ];
  
  services = {
    openssh = {
      enable = true;
    };
    
    disnix = {
      enable = true;
      infrastructure = {
        svnGroup = "root";
      };
    };
    
    svnserve = {
      enable = true;
    };
  };

  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.subversion
      pkgs.lynx
    ];
  };  
}
