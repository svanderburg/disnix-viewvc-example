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
      rootPassword = ./mysqlpw;
      initialScript = ./mysqlscript;
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
