{pkgs, ...}:

{
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
  
  networking.firewall.allowedTCPPorts = [ 3690 ];

  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.subversion
      pkgs.lynx
    ];
  };
}
