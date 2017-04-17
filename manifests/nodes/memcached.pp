#node 'ffl-wn-f2e02v.test.com' inherits  noarpnode {
node 'ffl-wn-memcached.test.com' inherits  basenode {
#  include nrpe_memcache
  include monit
  $ip_lan = "192.168.8.31"
  
  memcached::init_memcached { ["1271,2048","1272,2048","1286,1024","1270,1500"]: }
  monit_memcached::setmemconf{"monit_mem":
    memport => ["11271","11272","11286","11270"],
    memip => "$ip_lan"
  }
}
