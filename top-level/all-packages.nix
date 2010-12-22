{system ? builtins.currentSystem}:

let pkgs = import (builtins.getEnv "NIXPKGS_ALL") { inherit system; };
in
with pkgs;

rec {
  viewvc = import ../pkgs/viewvc {
    inherit stdenv fetchurl python;
    
    subversion = subversion.override {
      pythonBindings = true;
    };
  };
  
  ViewVCRepository = import ../pkgs/ViewVCRepository {
    inherit stdenv;
  };
}
