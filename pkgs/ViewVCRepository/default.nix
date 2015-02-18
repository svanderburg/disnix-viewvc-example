{stdenv}:

stdenv.mkDerivation {
  name = "ViewVCRepository";
  src = ./viewvc.dump;
  buildCommand = ''
    mkdir -p $out/subversion-repositories
    cp $src $out/subversion-repositories/viewvc.dump
  '';
}
