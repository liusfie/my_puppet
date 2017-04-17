class monit{
package {
	["monit"]:
	ensure => installed;
  }
  
  file { "monit_init":
    name =>"/etc/init.d/monit",
    mode =>755,
    ensure =>present,
    content =>template("monit/monit_init.erb"),
  }
  exec { "monit_graceful":
    command => "/etc/init.d/monit restart",
    path => ["/usr/bin", "/usr/sbin"],
    user => "root",
    refreshonly => true,
    onlyif => ["/usr/local/monit/bin/monit -t"],
  }
	
  define setmyconf ( $conf,$templatefile,$monit_ip,$ensure='present',$myport ) {
	file { $conf:
	mode=>700,
	ensure =>present,
	content => template($templatefile),
#	require=>Package [monit],
	}       
  }
  
  define setconf ( $conf,$templatefile,$monit_ip,$ensure='present' ) {
	file { $conf:
	ensure => present,
	content => template($templatefile),
	}       
  }

  define setconffile ( $conf,$conffile,$ensure='present' ) {
	file {$conf:
	path => $conf,
	ensure => present,
	owner     => root,
	group     => root,
	mode      => 700,
	source => "puppet://puppetmaster.light.soufun.com/modules/monit/$conffile",

		}
	}
	
  define baseconf ( $conf,$templatefile,$ensure='present' ) {
		file { $conf:
		content => template($templatefile),
#		require => Package [monit],
		mode =>700,

		}       
	}
   baseconf { "basemonit":
			   conf => "/usr/local/monit/etc/monit.d/base.cfg",
				 templatefile => "monit/base.cfg.erb",
				 notify => Exec ["monit_graceful"],
				 }
	
  baseconf { "monitrc":
     conf => "/usr/local/monit/etc/monitrc",
     templatefile => "monit/monitrc.erb",
     notify => Exec ["monit_graceful"],
  }

 baseconf { "sys_monit":
			   conf => "/usr/local/monit/etc/monit.d/sys_resource.cfg",
				 templatefile => "monit/sys_resource.cfg.erb",
				 notify => Exec ["monit_graceful"],
				 } 
				 

 baseconf { "rsyncd_init":
			   conf => "/etc/init.d/rsyncd",
				 templatefile => "monit/rsyncd.erb",
				 } 	
				 			 
  baseconf { "funcd_init":
    conf => "/etc/init.d/funcd",
    templatefile => "monit/funcd.erb",
  }
#  case $operatingsystem {
#    redhat: {
#      baseconf { "sshd_init":
#        conf => "/etc/init.d/sshd",
#        templatefile => "monit/sshd.erb",
#      }
#      baseconf { "snmpd_init":
#        conf => "/etc/init.d/snmpd",
#        templatefile => "monit/snmpd.erb",
#      }
#    }
#    centos: {
#      baseconf { "sshd_init":
#        conf => "/etc/init.d/sshd",
#        templatefile => "monit/centos_sshd.erb",
#      }
#      baseconf { "snmpd_init":
#        conf => "/etc/init.d/snmpd",
#        templatefile => "monit/centos_snmpd.erb",
#      }
#    }
#  }
}
