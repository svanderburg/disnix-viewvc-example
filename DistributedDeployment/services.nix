{distribution, system}:

let pkgs = import ../top-level/all-packages.nix { inherit system; };
in
rec {
  ViewVCRepository = {
    name = "ViewVCRepository";
    pkg = pkgs.ViewVCRepository;
    dependsOn = {};
    type = "subversion-repository";
  };

  viewvcdb = {
    name = "viewvcdb";
    pkg = pkgs.viewvcdb;
    dependsOn = {};
    type = "mysql-database";
  };

  viewvc = {
    name = "viewvc";
    pkg = pkgs.viewvc;
    dependsOn = {
      inherit viewvcdb;
      inherit ViewVCRepository;
    };
    type = "apache-webapplication";
  };  
}
