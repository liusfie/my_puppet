class monit_memcached{
  define setmemconf ( $memport,$memip ) {
    file { "/usr/local/monit/etc/monit.d/memcached.cfg":
	ensure => present,
	content => template("monit/memcached.cfg.erb"),
    }  
    exec { "memcached_monit":
        command => "/etc/init.d/monit restart",
        path => ["/usr/bin", "/usr/sbin"],
        user => "root",
        subscribe => File["/usr/local/monit/etc/monit.d/memcached.cfg"],
        refreshonly => true,
    }
  }		
}

