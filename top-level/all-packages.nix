{system, pkgs}:

let
  pkgs = import <nixpkgs> {
    config.permittedInsecurePackages = [
      "python-2.7.18.6"
    ];
  };

  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.pythonPackages // self);

  self = {
    ### Libraries

    pymysql = callPackage ../pkgs/pymysql { };

    ### Databases

    viewvcdb = callPackage ../pkgs/viewvcdb { };

    ### Subversion repositories

    ViewVCRepository = callPackage ../pkgs/ViewVCRepository { };

    aefs = callPackage ../pkgs/aefs { };

    maak = callPackage ../pkgs/maak { };

    ### Web front-end

    viewvc = callPackage ../pkgs/viewvc {
      subversion = pkgs.subversion.override {
        pythonBindings = true;
      };
    };
  };
in
self
