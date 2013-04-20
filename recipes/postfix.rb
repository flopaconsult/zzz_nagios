#
#
service "postfix" do
  action :enable
  supports :restart => true, :reload => true
end

template "/etc/postfix/main.cf" do
  source "main.cf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables :host => node[:fqdn]
  notifies :restart, resources(:service => "postfix")
end

cookbook_file "/etc/postfix/cacert.pem" do
  source "cacert.pem"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "postfix")
end

cookbook_file "/etc/postfix/swirl-cert.pem" do
  source "swirl-cert.pem"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "postfix")
end

cookbook_file "/etc/postfix/swirl-key.pem" do
  source "swirl-key.pem"
  owner "root"
  group "root"
  mode "0400"
  notifies :restart, resources(:service => "postfix")
end

cookbook_file "/etc/postfix/sasl_passwd" do
  source "sasl_passwd"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "postfix")
end

cookbook_file "/etc/postfix/sasl_passwd.db" do
  source "sasl_passwd.db"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "postfix")
end

link "/bin/mail"  do
  to "/usr/bin/mail"
end

