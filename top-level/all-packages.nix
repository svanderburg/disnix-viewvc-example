{system, pkgs}:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.pythonPackages // self);
  
  self = {
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
