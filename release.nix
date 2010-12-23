{ nixpkgs ? /etc/nixos/nixpkgs
, nixos ? /etc/nixos/nixos
, system ? builtins.currentSystem
}:

let
  pkgs = import nixpkgs { inherit system; };
  
  disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
    inherit nixpkgs nixos system;
  };

  jobs = rec {
    tarball =
      { viewvc ? {outPath = ./.; rev = 1234;}
      , officialRelease ? false}:
    
      disnixos.sourceTarball {
        name = "viewvc";
	version = builtins.readFile ./version;
	src = viewvc;
        inherit officialRelease;
      };
      
    build =
      { tarball ? jobs.tarball {} }:
      
      disnixos.buildManifest {
        name = "viewvc";
	version = builtins.readFile ./version;
	inherit tarball;
	servicesFile = "DistributedDeployment/services.nix";
	networkFile = "DistributedDeployment/network.nix";
	distributionFile = "DistributedDeployment/distribution.nix";
      };
            
    tests = 

      disnixos.disnixTest {
        name = "viewvc";
        tarball = tarball {};
        manifest = build {};
	networkFile = "DistributedDeployment/network.nix";
	testScript =
	  ''
	    $test3->mustSucceed("sleep 30; curl --fail http://test1/viewvc/bin/cgi/viewvc.cgi/aefs/trunk");
	    
	    # Start Firefox and take a screenshot
	    
	    $test3->mustSucceed("firefox http://test1/viewvc/bin/cgi/viewvc.cgi/aefs/trunk &");
	    $test3->waitForWindow(qr/Namoroka/);
	    $test3->mustSucceed("sleep 30");  
	    $test3->screenshot("screen");
	  '';
      };              
  };
in
jobs
