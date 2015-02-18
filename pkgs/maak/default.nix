{stdenv}:

stdenv.mkDerivation {
  name = "maak";
  src = ./svnrepodump-maak.gz;
  buildCommand = ''
    mkdir -p $out/subversion-repositories
    cp $src $out/subversion-repositories/svnrepodump-maak.gz
    gunzip $out/subversion-repositories/svnrepodump-maak.gz
  '';
}
