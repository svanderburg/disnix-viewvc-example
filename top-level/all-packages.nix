{system ? builtins.currentSystem}:

let pkgs = import (builtins.getEnv "NIXPKGS_ALL") { inherit system; };
in
with pkgs;

rec {
  ### Databases
  
  viewvcdb = import ../pkgs/viewvcdb {
    inherit stdenv;
  };

  ### Subversion repositories
  
  ViewVCRepository = import ../pkgs/ViewVCRepository {
    inherit stdenv;
  };
  
  aefs = import ../pkgs/aefs {
    inherit stdenv;
  };
  
  ### Web front-end
  
  viewvc = import ../pkgs/viewvc {
    inherit stdenv fetchurl enscript gnused python setuptools;
    inherit (pythonPackages) MySQL_python;
    
    subversion = subversion.override {
      pythonBindings = true;
    };
  };
}
