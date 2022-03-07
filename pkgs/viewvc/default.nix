{stdenv, lib, fetchurl, gnused, diffutils, python, subversion, pymysql, setuptools}:
interDependencies@{viewvcdb, ...}:

let
  subversionRepositories = builtins.removeAttrs interDependencies [ "viewvcdb" ];

  svnRoots = lib.concatMapStrings (serviceName:
    let repository = builtins.getAttr serviceName subversionRepositories;
    in
    "${repository.name}: svn://${repository.target.properties.hostname}/${repository.name}, ") (builtins.attrNames subversionRepositories);
in
stdenv.mkDerivation {
  name = "viewvc-1.2.1";
  src = fetchurl {
    url = http://www.viewvc.org/downloads/viewvc-1.2.1.tar.gz;
    sha256 = "0j9yl9w9bjxgrcl17wibqbl5m1lrkrd8abncyn8dys84zhsjvg5g";
  };
  buildInputs = [ python ];
  installPhase = ''
    python viewvc-install --prefix=$out/webapps/viewvc --destdir=

    # Add the Python Subversion and MySQL modules to the module search path

    MySQLpythonEgg=$(echo ${pymysql}/lib/python2.7/site-packages/*.egg)
    setuptoolsEgg=$(echo ${setuptools}/lib/python2.7/site-packages/*.egg)

    sed -i -e '/import os/asys.path.insert(0, "${subversion}/lib/python2.7/site-packages")' \
           -e '/import os/asys.path.insert(0, "'$setuptoolsEgg'")' \
           -e '/import os/asys.path.insert(0, "'$MySQLpythonEgg'")' \
           -e '/import os/aos.environ["PYTHON_EGG_CACHE"] = "/tmp"' \
           $out/webapps/viewvc/bin/cgi/viewvc.cgi

    sed -i -e '/import os/asys.path.insert(0, "${subversion}/lib/python2.7/site-packages")' \
           -e '/import os/asys.path.insert(0, "'$setuptoolsEgg'")' \
           -e '/import os/asys.path.insert(0, "'$MySQLpythonEgg'")' \
           -e '/import os/aos.environ["PYTHON_EGG_CACHE"] = "/tmp"' \
           $out/webapps/viewvc/bin/svndbadmin

    # Fix the path to sed so that syntax highlighting will work
    sed -i -e "s|'sed'|'${gnused}/bin/sed'|" $out/webapps/viewvc/lib/viewvc.py

    # Remove an assertion, preventing it from viewing remote repos. Seems to work fine without it.
    sed -i -e "s|assert type|# assert type|" $out/webapps/viewvc/lib/vclib/svn/svn_repos.py

    # Tweak the ViewVC configuration file

    sed -i -e "s%#svn_roots =%svn_roots = ${svnRoots}%" \
           -e "s/#root_as_url_component = 0/root_as_url_component = 1/" \
           -e "s/#enabled = 1/enabled = 1/" \
           -e "s/#host =/host = ${viewvcdb.target.properties.hostname}/" \
           -e "s/#port = 3306/port = ${toString viewvcdb.target.container.mysqlPort}/" \
           -e "s/#database_name = ViewVC/database_name = ${viewvcdb.name}/" \
           -e "s/#user =/user = ${viewvcdb.mysqlUsername}/" \
           -e "s/#passwd =/passwd = ${viewvcdb.mysqlPassword}/" \
           -e "s/#readonly_user =/readonly_user = ${viewvcdb.mysqlUsername}/" \
           -e "s/#readonly_passwd =/readonly_passwd = ${viewvcdb.mysqlPassword}/" \
           -e "s|#svn =|svn = ${subversion}/bin/svn|" \
           -e "s|#diff =|diff = ${diffutils}/bin/diff|" \
           -e "s|#enabled = 0|enabled = 1|" \
    $out/webapps/viewvc/viewvc.conf

    # Add htaccess file which allows execution of cgi-scripts
    cat > $out/webapps/viewvc/.htaccess <<EOF
    AddHandler cgi-script .cgi
    Options +ExecCGI
    EOF

    # Remove bytecode files to make the earlier changes are actually used
    rm `find $out/webapps/viewvc -name \*.pyc`
  '';
}
