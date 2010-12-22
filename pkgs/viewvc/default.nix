{stdenv, fetchurl, python, subversion}:
subversionRepositories:

let
  svnRoots = stdenv.lib.concatMapStrings (serviceName:
    let repository = builtins.getAttr serviceName subversionRepositories;
    in
    "${repository.name}: svn://${repository.target.hostname}/${repository.name}, ") (builtins.attrNames subversionRepositories);
in
stdenv.mkDerivation {
  name = "viewvc-1.0.12";
  src = fetchurl {
    url = http://viewvc.tigris.org/files/documents/3330/47621/viewvc-1.0.12.tar.gz;
    sha256 = "1zcmb5i7v3zhanyx6pahk4aiv66dw03s5j1yh6gxf1ns67ij28dj";  
  };
  buildInputs = [ python ];
  installPhase = ''
    python viewvc-install --prefix=$out/webapps/viewvc --destdir=
    
    # Add the Python Subversion module to the module search path
    sed -i -e '/import os/asys.path.insert(0, "${subversion}/lib/python2.6/site-packages")' $out/webapps/viewvc/bin/cgi/viewvc.cgi
    
    # Tweak the ViewVC configuration file
    
    sed -i -e "s/cvs_roots =/#cvs_roots =/" \
           -e "s%#svn_roots = svn: /home/svnrepos%svn_roots = ${svnRoots}%" \
           -e "s/root_as_url_component = 0/root_as_url_component = 1/" \
    $out/webapps/viewvc/viewvc.conf
    
    # Add htaccess file which allows execution of cgi-scripts
    cat > $out/webapps/viewvc/.htaccess <<EOF
    AddHandler cgi-script .cgi
    Options +ExecCGI
    EOF
  '';
}
