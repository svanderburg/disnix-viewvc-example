{
  test1 = {
    hostname = "test1";
    documentRoot = "/var/www";
    mysqlPort = 3307;
    mysqlUsername = "root";
    mysqlPassword = builtins.readFile ../configurations/mysqlpw;
  };
  
  test2 = {
    hostname = "test2";
    svnBaseDir = "/repos";
    svnGroup = "root";
  };
}
