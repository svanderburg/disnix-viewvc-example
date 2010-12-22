{system ? builtins.currentSystem}:

let pkgs = import (builtins.getEnv "NIXPKGS_ALL") { inherit system; };
in
with pkgs;

rec {
  viewvcdb = import ../pkgs/viewvcdb {
    inherit stdenv;
  };

  viewvc = import ../pkgs/viewvc {
    inherit stdenv fetchurl python setuptools;
    inherit (pythonPackages) MySQL_python;
    
    subversion = subversion.override {
      pythonBindings = true;
    };
  };
  
  ViewVCRepository = import ../pkgs/ViewVCRepository {
    inherit stdenv;
  };
}
