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
      package = pkgs.mariadb;
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 3306 ];

  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.6"
  ];

  environment = {
    systemPackages = [
      pkgs.mc
      pkgs.subversion
      pkgs.lynx
    ];
  };
}
