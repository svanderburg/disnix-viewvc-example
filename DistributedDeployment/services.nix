{distribution, system}:

let pkgs = import ../top-level/all-packages.nix { inherit system; };
in
rec {
  ### Subversion repositories
  
  ViewVCRepository = {
    name = "ViewVCRepository";
    pkg = pkgs.ViewVCRepository;
    dependsOn = {};
    type = "subversion-repository";
  };
  
  aefs = {
    name = "aefs";
    pkg = pkgs.aefs;
    dependsOn = {};
    type = "subversion-repository";
  };

  maak = {
    name = "maak";
    pkg = pkgs.maak;
    dependsOn = {};
    type = "subversion-repository";
  };

  ### Databases
  
  viewvcdb = {
    name = "viewvcdb";
    pkg = pkgs.viewvcdb;
    dependsOn = {};
    type = "mysql-database";
  };

  ### Web front-ends
  
  viewvc = {
    name = "viewvc";
    pkg = pkgs.viewvc;
    dependsOn = {
      inherit viewvcdb;
      inherit ViewVCRepository aefs maak; # Add your own subversion repositories here
    };
    type = "apache-webapplication";
  };  
}
