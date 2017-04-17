node 'ffl-wn-f2e02v.test.com' inherits basenode{  
#	include baseusers
	include lvs_install
#	include basecron
#	include lvs
#	include nrpe_lvs
#	lvs::setconf{"lvs_N_M_test":
#		keepalivedconf => "/usr/local/keepalived/etc/keepalived.conf",
#		stateType => 'BACKUP',
#		state => 'MASTER',
#		templatefile => "lvs/sh/keepalived.erb",
#		}
#		
#	macabout::set_maclist{"syq_maclist":
#  	}
#  	include grub
}
