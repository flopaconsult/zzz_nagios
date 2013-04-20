package "rrdtool"  do
  action :install
end

##check to see if its installed: perl -MRRDs -le 'print q(ok!)'
##[http://ronaldbradford.com/blog/installing-perl-rrd-module-rrdspm-2009-07-11/]
package "librrds-perl"  do
  action :install
end



#wget http://cdnetworks-us-1.dl.sourceforge.net/project/nagiosgraph/nagiosgraph/1.4.4/nagiosgraph-1.4.4.tar.gz
cookbook_file "/tmp/nagiosgraph-1.4.4.tar.gz"  do
  source "nagiosgraph-1.4.4.tar.gz"
  mode 0644
  owner "root"
  group "root"
#  not_if do File.exists?("/var/lib/nagios/libexec/check_mysql_health") end
end

bash "install nagiosgraph" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    tar -xvf nagiosgraph-1.4.4.tar.gz
    cd nagiosgraph-1.4.4
    mkdir /opt/nagiosgraph
    cp nagiosgraph.conf map show.cgi insert.pl /opt/nagiosgraph
    cp nagiosgraph.css /opt/nagios/share/stylesheets
    mkdir -p /var/opt/nagiosgraph/rrd
    touch /var/opt/nagiosgraph/nagiosgraph.log
    chown -R nagios.nagcmd /opt/nagiosgraph
    chown -R nagios.nagcmd /var/opt/nagiosgraph
    chmod 2775 /var/opt/nagiosgraph
    chmod 664 /var/opt/nagiosgraph/nagiosgraph.log
  EOH
  not_if do File.exists?("/var/lib/nagios/libexec/check_mysql_health") end
end


