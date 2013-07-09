{ nixpkgs ? <nixpkgs>
, nixos ? <nixos>
}:

let

  jobs = rec {
    tarball =
      { viewvc ? {outPath = ./.; rev = 1234;}
      , officialRelease ? false}:
    
      let
        pkgs = import nixpkgs {};
  
        disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
          inherit nixpkgs nixos;
        };
      in
      disnixos.sourceTarball {
        name = "viewvc";
        version = builtins.readFile ./version;
        src = viewvc;
        inherit officialRelease;
      };
      
    doc =
      { tarball ? jobs.tarball {} }:
      
      with import nixpkgs {};
      
      releaseTools.nixBuild {
        name = "viewvc-doc";
        version = builtins.readFile ./version;
        src = tarball;
        buildInputs = [ libxml2 libxslt dblatex tetex ];
        
        buildPhase = ''
          cd doc
          make docbookrng=${docbook5}/xml/rng/docbook docbookxsl=${docbook5_xsl}/xml/xsl/docbook
        '';
        
        checkPhase = "true";
        
        installPhase = ''
          make DESTDIR=$out install
         
          echo "doc manual $out/share/doc/viewvc/manual" >> $out/nix-support/hydra-build-products
        '';
      };

    build =
      { tarball ? jobs.tarball {}
      , system ? "x86_64-linux"
      }:
      
      let
        pkgs = import nixpkgs { inherit system; };
  
        disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
          inherit nixpkgs nixos system;
        };
      in
      disnixos.buildManifest {
        name = "viewvc";
        version = builtins.readFile ./version;
        inherit tarball;
        servicesFile = "DistributedDeployment/services.nix";
        networkFile = "DistributedDeployment/network.nix";
        distributionFile = "DistributedDeployment/distribution.nix";
      };
    
    tests = 

      let
        pkgs = import nixpkgs {};
  
        disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
          inherit nixpkgs nixos;
        };
      in
      disnixos.disnixTest {
        name = "viewvc";
        tarball = tarball {};
        manifest = build { system = "x86_64-linux"; };
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
