

#wget http://labs.consol.de/wp-content/uploads/2010/12/check_mysql_health-2.1.5.tar.gz
cookbook_file "/tmp/check_mysql_health-2.1.5.tar.gz"  do
  source "check_mysql_health-2.1.5.tar.gz"
  mode 0644
  owner "root"
  group "root"
  not_if do File.exists?("/var/lib/nagios/libexec/check_mysql_health") end
end

package "mysql-client"  do
  action :install
end

bash "install check_mysql_health" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    PERL_MM_USE_DEFAULT=1 cpan YAML
    PERL_MM_USE_DEFAULT=1 cpan DBI
    PERL_MM_USE_DEFAULT=1 cpan DBD::mysql
    tar -xvf check_mysql_health-2.1.5.tar.gz
    cd check_mysql_health-2.1.5
    ./configure --prefix=/var/lib/nagios --with-nagios-user=nagios --with-nagios-group=nagios --with-perl=/usr/bin/perl
    make
    make install
    cd ..
    rm -r check_mysql_health-2.1.5
  EOH
  not_if do File.exists?("/var/lib/nagios/libexec/check_mysql_health") end
end


