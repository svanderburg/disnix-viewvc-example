{distribution, invDistribution, system, pkgs}:

let customPkgs = import ../top-level/all-packages.nix { inherit system pkgs; };
in
rec {
  ### Subversion repositories

  ViewVCRepository = {
    name = "ViewVCRepository";
    pkg = customPkgs.ViewVCRepository;
    dependsOn = {};
    type = "subversion-repository";
  };

  aefs = {
    name = "aefs";
    pkg = customPkgs.aefs;
    dependsOn = {};
    type = "subversion-repository";
  };

  maak = {
    name = "maak";
    pkg = customPkgs.maak;
    dependsOn = {};
    type = "subversion-repository";
  };

  ### Databases

  viewvcdb = rec {
    name = "viewvcdb";
    mysqlUsername = "viewvcdb";
    mysqlPassword = "viewvcdb";
    pkg = customPkgs.viewvcdb {
      inherit mysqlUsername mysqlPassword;
    };
    dependsOn = {};
    type = "mysql-database";
  };

  ### Web front-ends

  viewvc = {
    name = "viewvc";
    pkg = customPkgs.viewvc;
    dependsOn = {
      inherit viewvcdb;
      inherit ViewVCRepository aefs maak; # Add your own subversion repositories here
    };
    type = "apache-webapplication";
  };
}
