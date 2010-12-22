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

  viewvc = {
    name = "viewvc";
    pkg = pkgs.viewvc;
    dependsOn = {
      inherit ViewVCRepository;
    };
    type = "apache-webapplication";
  };  
}
