#!/bin/bash
CronDate="05 00 * * *"
CronPath="/var/spool/cron/root"
ShellDir="/www/soufun"
rel=`cat /etc/redhat-release|grep 'AS'`
if [ -n "$rel" ]
then
exit 1
fi
if [ ! -d $ShellDir ]
then
mkdir -p /www/soufun
fi
cat > /bin/puppetd <<EOF
#!/bin/bash
logdir="/opt/puppetlog"
if [ ! -f \$logdir ]
then
mkdir -p \$logdir
fi
/usr/bin/puppet agent -t --server puppetmaster.light.soufun.com -l \$logdir/puppet.log  \$1 \$2
EOF
chmod 755 /bin/puppetd
cat >$ShellDir/cut_puppet_log.sh <<MYSHELL
#!/bin/bash
nowdate=\`date +%Y%m%d\`
olddate=\`date -d "yesterday" +%Y%m%d\`
deldate=\`date -d "30 days ago" +%Y%m%d\`
logdir="/opt/puppetlog"
if [ -f \$logdir/puppet.log ]
then
mv \$logdir/puppet.log \$logdir/puppet.log_\$olddate
gzip -f \$logdir/puppet.log_\$olddate
rm -rf \$logdir/puppet.log_\$deldate.gz
else
exit 1
fi
MYSHELL
CheckCron=`crontab -l|grep -n "cut_puppet_log.sh"|wc -l`
if [ $CheckCron -eq 0 ]
then
echo "$CronDate (sh $ShellDir/cut_puppet_log.sh)">>$CronPath
fi
##################begin soft install#########
#/etc/init.d/iptables stop

os=`cat /etc/redhat-release |grep  "CentOS"|awk '{print $1}'`
if [ $os = "CentOS" ]
then
  cd /www/soufun/
  #wget http://install.light.soufun.com/puppet-3.7.3-1.el6.noarch.rpm
  #wget http://install.light.soufun.com/epel-release-6-8.noarch.rpm
  #wget http://install.light.soufun.com/puppetlabs-release-6-5.noarch.rpm

  #rpm -ivh epel-release-6-8.noarch.rpm
  #rpm -ivh puppetlabs-release-6-5.noarch.rpm
   grep "7." /etc/redhat-release &>/dev/null
   if [ $? -eq 0 ];then
     yum -y install  puppet
   else
     yum install -y  ruby-devel rubygems  puppet-3.7.3-1.el6.noarch
   fi
  #rm puppet-3.7.3-1.el6.noarch.rpm 
  #rm epel-release-6-8.noarch.rpm 
  #rm puppetlabs-release-6-5.noarch.rpm
else
   cd /www/soufun/
  #wget http://install.light.soufun.com/puppet-3.7.3-1.el5.noarch.rpm
  #wget http://install.light.soufun.com/epel-release-5-4.noarch.rpm
  #wget http://install.light.soufun.com/puppetlabs-release-5-11.noarch.rpm

  #rpm -ivh epel-release-5-4.noarch.rpm
  #rpm -ivh puppetlabs-release-5-11.noarch.rpm

   yum install -y  ruby-devel rubygems  puppet-3.7.3-1.el5.noarch

  #rm puppet-3.7.3-1.el5.noarch.rpm
  #rm epel-release-5-4.noarch.rpm
  #rm puppetlabs-release-5-11.noarch.rpm
fi

#/etc/init.d/iptables start
#mv /etc/yum.repos.d/epel.repo    /etc/yum.repos.d/epel.repo-bk
#yum clean all
##################end soft install ############# 
cp /etc/hosts /root/hosts$$
if [ -d "/var/lib/puppet/ssl" ]
then
rm -rf /var/lib/puppet/ssl/*
fi
if [ -d "/etc/puppet/ssl" ]
then
rm -rf /etc/puppet/ssl/*
fi
cat >/etc/puppet/puppet.conf <<EOF
[agent]
report = true
server = puppetmaster.light.soufun.com
ca_server = puppetca.light.soufun.com
runinterval = 43200
factpath=$vardir/lib/facter
pluginsync=true
EOF
cp -rf /etc/hosts /root/hosts$$
grep "^127.0.0.1" /etc/hosts|grep -wq "$HOSTNAME "
if [ $? -ne 0 ];then
        sed "/127.0.0.1/ s/$/    $HOSTNAME /g" /etc/hosts -i
fi
grep "^::1" /etc/hosts|grep -wq "$HOSTNAME "
if [ $? -ne 0 ];then
        sed "/::1/ s/$/    $HOSTNAME /g" /etc/hosts -i
fi
grep "^::1" /etc/hosts|grep -wq $HOSTNAME.light.soufun.com
if [ $? -ne 0 ];then
        sed "/::1/ s/^::1/::1    $HOSTNAME.light.soufun.com    /g" /etc/hosts -i
fi
grep "^127.0.0.1" /etc/hosts|grep -wq $HOSTNAME.light.soufun.com
if [ $? -ne 0 ];then
        sed "/127.0.0.1/ s/^127.0.0.1/127.0.0.1    $HOSTNAME.light.soufun.com    /g" /etc/hosts -i
fi
/usr/bin/puppet agent -t --server puppetmaster.light.soufun.com --noop


