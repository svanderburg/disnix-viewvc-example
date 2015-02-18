{stdenv}:

stdenv.mkDerivation {
  name = "viewvcdb";
  src = ./viewvc.sql;
  buildCommand =
  ''
    mkdir -p $out/mysql-databases
    cp $src $out/mysql-databases/viewvc.sql
  '';
}
