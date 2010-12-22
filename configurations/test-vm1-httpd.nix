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
    };
    
    httpd = {
      enable = true;
      documentRoot = "/var/www";
      adminAddr = "admin@localhost";
      extraConfig = ''
        <Directory /var/www>
          AllowOverride all
	</Directory>
      '';
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
