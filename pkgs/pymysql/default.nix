{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "PyMySQL";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JjBA0neaO4STD3rJ2lEyvg/vzW9FOohXVmVhA/juH90=";
  };

  # Wants to connect to MySQL
  doCheck = false;

  meta = with lib; {
    description = "Pure Python MySQL Client";
    homepage = "https://github.com/PyMySQL/PyMySQL";
    license = licenses.mit;
  };
}
