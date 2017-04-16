node basenode {
  case $operatingsystem { 
    redhat: {
#      include deluser 
#      include ppcnf
#      include ppms 
#      include limits
#      include yum_package
#      include basecron
    }
    centos: {
#      include deluser 
#      include ppcnf
#      include ppms 
#      include limits
#      include yum_package
#      include basecron
    }
	solaris: {
#		include ppcnf
#		file {"/opt/csw/lib/ruby/site_ruby/1.8/puppet/provider/package/pkgutil.rb":
#			source => "puppet://puppetmaster.light.soufun.com/soufun/pkgutil.rb",
#			owner => "root",
#			group => "root",
#			mode  => 644,
#			}
		}
    windows: {}
    default: {
#      include ppcnf
    }
  }

  if ($hostname!~/(.*)lvs|jyw-o-gw(.*)|(.*)vpn|ja-o-dns02v(.*)/) {
#    include noarpctl
  }
		
}
