{stdenv}:

stdenv.mkDerivation {
  name = "viewvcdb";
  src = ./viewvc.sql;
  buildCommand =
  ''
    ensureDir $out/mysql-databases
    cp $src $out/mysql-databases/viewvc.sql
  '';
}
