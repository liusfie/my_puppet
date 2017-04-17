class lvs_install {

package {
	[openssl-devel]:
	provider => yum,
	ensure => installed,
	before => exec["lvs_install"],
	}

  exec { "lvs_install": 
    cwd => "/tmp",
    command => "wget http://install.light.soufun.com/install_lvs.2.4.sh;sh install_lvs.2.4.sh",
    user => "root",
    path => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin",
    unless => "test -d /usr/local/keepalived"
  }

}
