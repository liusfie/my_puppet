node ffl-wn-f2ev {
  $packages = [ "monit", "sysstat" ]
  file {"/tmp/test.txt":
    mode =>400,
    owner =>root,
    group => root,
    source =>"puppet:///file/test.txt",
  }
  package { $packages:
        ensure => installed,
  }
}


node default {
  notify{
    "error! not match your node , this is default node":
  }
}
