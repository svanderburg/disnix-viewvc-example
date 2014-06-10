{pkgs, ...}:

{
  services = {
    disnix = {
      enable = true;
    };
    
    openssh = {
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
    
    mysql = {
      enable = true;
      package = pkgs.mysql;
      rootPassword = ./mysqlpw;
      initialScript = ./mysqlscript;
    };
  };
  
  networking.firewall.allowedTCPPorts = [ 80 3306 ];
  
  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.subversion
      pkgs.lynx
    ];
  };
}
