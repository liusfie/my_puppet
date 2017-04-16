class memcached {
  define init_memcached () {
    if $name=~/(.*),(.*)/ {
      $myport=$1
      $ccsz=$2
      file { "/etc/init.d/memcached_1${myport}":
	owner=>root,
	group=>root,
	mode=>700,
	ensure=>present,
	content=>template("memcached/memcached.erb"),
      }
    }
  }
}
