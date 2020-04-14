{stdenv}:
{mysqlUsername, mysqlPassword}:

stdenv.mkDerivation rec {
  name = "viewvcdb";
  src = ./viewvc.sql;
  buildCommand =
  ''
    mkdir -p $out/mysql-databases
    (
      echo "grant all on ${name}.* to '${mysqlUsername}'@'localhost' identified by '${mysqlPassword}';"
      echo "grant all on ${name}.* to '${mysqlUsername}'@'%' identified by '${mysqlPassword}';"
      cat *.sql
      echo "flush privileges;"
    ) > $out/mysql-databases/viewvc.sql
  '';
}
