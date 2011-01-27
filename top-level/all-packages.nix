{system, pkgs}:

rec {
  ### Databases
  
  viewvcdb = import ../pkgs/viewvcdb {
    inherit (pkgs) stdenv;
  };

  ### Subversion repositories
  
  ViewVCRepository = import ../pkgs/ViewVCRepository {
    inherit (pkgs) stdenv;
  };
  
  aefs = import ../pkgs/aefs {
    inherit (pkgs) stdenv;
  };
  
  maak = import ../pkgs/maak {
    inherit (pkgs) stdenv;
  };
  
  ### Web front-end
  
  viewvc = import ../pkgs/viewvc {
    inherit (pkgs) stdenv fetchurl enscript gnused python setuptools;
    inherit (pkgs.pythonPackages) MySQL_python;
    
    subversion = pkgs.subversion.override {
      pythonBindings = true;
    };
  };
}
