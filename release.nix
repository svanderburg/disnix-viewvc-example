{ nixpkgs ? <nixpkgs>
, viewvc ? {outPath = ./.; rev = 1234;}
, officialRelease ? false
, systems ? [ "i686-linux" "x86_64-linux" ]
}:

let
  pkgs = import nixpkgs {};
  
  jobs = rec {
    tarball =
      let
        disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
          inherit nixpkgs;
        };
      in
      disnixos.sourceTarball {
        name = "viewvc";
        version = builtins.readFile ./version;
        src = viewvc;
        inherit officialRelease;
      };
      
    build =
      pkgs.lib.genAttrs systems (system:
        let
          disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
            inherit nixpkgs system;
          };
        in
        disnixos.buildManifest {
          name = "viewvc";
          version = builtins.readFile ./version;
          inherit tarball;
          servicesFile = "DistributedDeployment/services.nix";
          networkFile = "DistributedDeployment/network.nix";
          distributionFile = "DistributedDeployment/distribution.nix";
        });
    
    tests = 
      let
        disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
          inherit nixpkgs;
        };
      in
      disnixos.disnixTest {
        name = "viewvc";
        inherit tarball;
        manifest = builtins.getAttr (builtins.currentSystem) build;
        networkFile = "DistributedDeployment/network.nix";
        testScript =
          ''
            $test3->mustSucceed("sleep 30; curl --fail http://test1/viewvc/bin/cgi/viewvc.cgi/aefs/trunk");
            
            # Start Firefox and take a screenshot
            
            $test3->mustSucceed("firefox http://test1/viewvc/bin/cgi/viewvc.cgi/aefs/trunk &");
            $test3->waitForWindow(qr/Nightly/);
            $test3->mustSucceed("sleep 30");
            $test3->screenshot("screen");
          '';
      };
  };
in
jobs
