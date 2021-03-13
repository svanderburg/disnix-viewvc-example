{ pkgs, system, distribution, invDistribution
, stateDir ? "/var"
, runtimeDir ? "${stateDir}/run"
, logDir ? "${stateDir}/log"
, cacheDir ? "${stateDir}/cache"
, spoolDir ? "${stateDir}/spool"
, tmpDir ? (if stateDir == "/var" then "/tmp" else "${stateDir}/tmp")
, forceDisableUserChange ? false
, processManager ? "sysvinit"
, nix-processmgmt ? ../../../nix-processmgmt
, nix-processmgmt-services ? ../../../nix-processmgmt-services
}:

let
  processType = import "${nix-processmgmt}/nixproc/derive-dysnomia-process-type.nix" {
    inherit processManager;
  };

  constructors = import "${nix-processmgmt-services}/service-containers-agnostic/constructors.nix" {
    inherit nix-processmgmt pkgs stateDir runtimeDir logDir cacheDir spoolDir tmpDir forceDisableUserChange processManager;
  };

  applicationServices = import ./services.nix {
    inherit pkgs system distribution invDistribution;
  };
in
rec {
  svnserve = constructors.svnserve {
    svnBaseDir = "/repos";
    svnGroup = "root";
    type = processType;
  };

  mysql = constructors.mysql {
    port = 3306;
    type = processType;
  };

  apache = constructors.simpleWebappApache rec {
    port = 80;
    serverAdmin = "root@localhost";
    enablePHP = true;
    enableCGI = true;
    documentRoot = "${stateDir}/www";
    extraConfig = ''
      <Directory ${documentRoot}>
        AllowOverride all
      </Directory>
    '';
    type = processType;
  };
} // applicationServices
