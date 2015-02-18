{stdenv}:

stdenv.mkDerivation {
  name = "aefs";
  src = ./svnrepodump-aefs.gz;
  buildCommand = ''
    mkdir -p $out/subversion-repositories
    cp $src $out/subversion-repositories/svnrepodump-aesfs.gz
    gunzip $out/subversion-repositories/svnrepodump-aesfs.gz
  '';
}
