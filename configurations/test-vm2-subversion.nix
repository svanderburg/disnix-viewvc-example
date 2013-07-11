{pkgs, ...}:

{
  services = {
    disnix = {
      enable = true;
    };
    
    openssh = {
      enable = true;
    };
    
    disnix = {
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
