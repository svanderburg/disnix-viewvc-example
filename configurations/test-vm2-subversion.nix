{pkgs, ...}:

{
  services = {
    openssh = {
      enable = true;
    };
    
    disnix = {
      enable = true;
    };
    
    svnserve = {
      enable = true;
    };
  };
  
  dysnomia = {
    extraContainerProperties = {
      subversion-repository = {
        svnGroup = "root";
      };
    };
  };
  
  networking.firewall.allowedTCPPorts = [ 3690 ];

  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.subversion
      pkgs.lynx
    ];
  };
}
