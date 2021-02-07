{ nixpkgs ? <nixpkgs>
, viewvc ? { outPath = ./.; rev = 1234; }
, nix-processmgmt ? { outPath = ../nix-processmgmt; rev = 1234; }
, nix-processmgmt-services ? { outPath = ../nix-processmgmt-services; rev = 1234; }
, officialRelease ? false
, systems ? [ "i686-linux" "x86_64-linux" ]
}:

let
  pkgs = import nixpkgs {};

  disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
    inherit nixpkgs;
  };

  version = builtins.readFile ./version;

  jobs = rec {
    tarball = disnixos.sourceTarball {
      name = "viewvc";
      src = viewvc;
      inherit officialRelease version;
    };

    build = {
      services = pkgs.lib.genAttrs systems (system:
        let
          disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
            inherit nixpkgs system;
          };
        in
        disnixos.buildManifest {
          name = "viewvc";
          inherit tarball version;
          servicesFile = "DistributedDeployment/services.nix";
          networkFile = "DistributedDeployment/network.nix";
          distributionFile = "DistributedDeployment/distribution.nix";
        });

      services-with-containers = pkgs.lib.genAttrs systems (system:
        let
          disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
            inherit nixpkgs system;
          };
        in
        disnixos.buildManifest {
          name = "viewvc";
          inherit tarball version;
          servicesFile = "DistributedDeployment/services-with-containers.nix";
          networkFile = "DistributedDeployment/network-bare.nix";
          distributionFile = "DistributedDeployment/distribution-with-containers.nix";
          extraParams = {
            inherit nix-processmgmt nix-processmgmt-services;
          };
        });
    };

    tests =
      let
        testApp = {networkFile, manifest}:

        disnixos.disnixTest {
          name = "viewvc";
          inherit tarball manifest networkFile;
          testScript =
            ''
              test3.succeed("sleep 30; curl --fail http://test1/viewvc/bin/cgi/viewvc.cgi/aefs/trunk")

              # Start Firefox and take a screenshot

              test3.succeed("firefox http://test1/viewvc/bin/cgi/viewvc.cgi/aefs/trunk &")
              test3.wait_for_window("Firefox")
              test3.succeed("sleep 30")
              test3.screenshot("screen")
            '';
         };
      in
      {
        services = testApp {
          manifest = builtins.getAttr (builtins.currentSystem) build.services;
          networkFile = "DistributedDeployment/network.nix";
        };

        services-with-containers = testApp {
          manifest = builtins.getAttr (builtins.currentSystem) build.services-with-containers;
          networkFile = "DistributedDeployment/network-bare.nix";
        };
      };
  };
in
jobs
