{
  test1 = {
    properties = {
      hostname = "test1";
    };
    containers = {
      apache-webapplication = {
        documentRoot = "/var/www";
      };
      
      mysql-database = {
        mysqlPort = 3307;
        mysqlUsername = "root";
        mysqlPassword = builtins.readFile ../configurations/mysqlpw;
      };
    };
  };
  
  test2 = {
    properties = {
      hostname = "test2";
    };
    containers = {
      subversion-repository = {
        svnBaseDir = "/repos";
        svnGroup = "root";
      };
    };
  };
}
