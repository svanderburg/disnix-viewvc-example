{infrastructure}:

let
  applicationServicesDistribution = import ./distribution.nix {
    inherit infrastructure;
  };
in
{
  svnserve = [ infrastructure.test2 ];
  mysql = [ infrastructure.test1 ];
  apache = [ infrastructure.test1 ];
} // applicationServicesDistribution
