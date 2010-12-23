{stdenv, fetchurl, enscript, gnused, python, subversion, MySQL_python, setuptools}:
interDependencies@{viewvcdb, ...}:

let
  subversionRepositories = builtins.removeAttrs interDependencies [ "viewvcdb" ];
  
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

    # Add the Python Subversion and MySQL modules to the module search path
    
    MySQLpythonEgg=$(echo ${MySQL_python}/lib/python2.6/site-packages/*.egg)
    setuptoolsEgg=$(echo ${setuptools}/lib/python2.6/site-packages/*.egg)
    
    sed -i -e '/import os/asys.path.insert(0, "${subversion}/lib/python2.6/site-packages")' \
           -e '/import os/asys.path.insert(0, "'$setuptoolsEgg'")' \
           -e '/import os/asys.path.insert(0, "'$MySQLpythonEgg'")' \
           -e '/import os/aos.environ["PYTHON_EGG_CACHE"] = "/tmp"' \
           $out/webapps/viewvc/bin/cgi/viewvc.cgi

    sed -i -e '/import os/asys.path.insert(0, "${subversion}/lib/python2.6/site-packages")' \
           -e '/import os/asys.path.insert(0, "'$setuptoolsEgg'")' \
           -e '/import os/asys.path.insert(0, "'$MySQLpythonEgg'")' \
           -e '/import os/aos.environ["PYTHON_EGG_CACHE"] = "/tmp"' \
           $out/webapps/viewvc/bin/svndbadmin

    # Fix the path to sed so that syntax highlighting will work
    sed -i -e "s|'sed'|'${gnused}/bin/sed'|" $out/webapps/viewvc/lib/viewvc.py

    # Tweak the ViewVC configuration file

    sed -i -e "s/cvs_roots =/#cvs_roots =/" \
           -e "s%#svn_roots = svn: /home/svnrepos%svn_roots = ${svnRoots}%" \
           -e "s/root_as_url_component = 0/root_as_url_component = 1/" \
           -e "s/enabled = 0/enabled = 1/" \
           -e "s/use_enscript = 0/use_enscript = 1/" \
           -e "s%enscript_path =%enscript_path = ${enscript}/bin/%" \
           -e "s/#host = localhost/host = ${viewvcdb.target.hostname}/" \
           -e "s/#port = 3306/port = ${toString viewvcdb.target.mysqlPort}/" \
           -e "s/#database_name = ViewVC/database_name = ${viewvcdb.name}/" \
           -e "s/#user =/user = ${viewvcdb.target.mysqlUsername}/" \
           -e "s/#passwd =/passwd = ${viewvcdb.target.mysqlPassword}/" \
           -e "s/#readonly_user =/readonly_user = ${viewvcdb.target.mysqlUsername}/" \
           -e "s/#readonly_passwd =/readonly_passwd = ${viewvcdb.target.mysqlPassword}/" \
    $out/webapps/viewvc/viewvc.conf

    # Add htaccess file which allows execution of cgi-scripts
    cat > $out/webapps/viewvc/.htaccess <<EOF
    AddHandler cgi-script .cgi
    Options +ExecCGI
    EOF
  '';
}
