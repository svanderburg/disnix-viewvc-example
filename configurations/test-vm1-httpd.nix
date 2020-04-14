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
      adminAddr = "admin@localhost";
      virtualHosts.localhost = {
        documentRoot = "/var/www";
        extraConfig = ''
          <Directory /var/www>
            AllowOverride all
          </Directory>
        '';
      };
    };

    mysql = {
      enable = true;
      package = pkgs.mysql;
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
