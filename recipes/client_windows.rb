#
# Cookbook Name:: windows_nagios
# Recipe:: client
# Author:: Valeriu Craciun
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

dir = node[:nagios_client][:dir]
home = "C:\\Program Files\\NSClient++"
service_name = "nscp"
msi = node[:nagios_client][:msi]
dst = "#{dir}\\#{msi}"

remote_file dst do
  source "#{node[:nagios_client][:mirror]}/#{msi}"
  not_if { File.exists?(dst) }
end



# execute silent install
execute "install #{msi}" do
  cwd node[:nagios_client][:dir]
  command "msiexec /i #{msi} /quiet"
  notifies :delete, "file[#{dst}]", :immediately
end



# unlock ports in firewall
firewall_rule_name_check_nt = "#{node[:nagios_client][:instance_name]} check_nt Port"
execute "open-static-port-check-nt" do
  command "netsh advfirewall firewall add rule name=\"#{firewall_rule_name_check_nt}\" dir=in action=allow protocol=TCP localport=#{node['nagios_client']['check_nt_port']}"
  returns [0,1,42] # *sigh* cmd.exe return codes are wonky
  not_if { Nagios::Helper.firewall_rule_enabled?(firewall_rule_name_check_nt) }
end

firewall_rule_name_check_nrpe = "#{node[:nagios_client][:instance_name]} check_nrpe Port"
execute "open-static-port-check-nrpe" do
  command "netsh advfirewall firewall add rule name=\"#{firewall_rule_name_check_nrpe}\" dir=in action=allow protocol=TCP localport=#{node['nagios_client']['check_nrpe_port']}"
  returns [0,1,42] # *sigh* cmd.exe return codes are wonky
  not_if { Nagios::Helper.firewall_rule_enabled?(firewall_rule_name_check_nrpe) }
end

firewall_rule_name_check_nsca = "#{node[:nagios_client][:instance_name]} check_nsca Port"
execute "open-static-port-check-nsca" do
  command "netsh advfirewall firewall add rule name=\"#{firewall_rule_name_check_nsca}\" dir=in action=allow protocol=TCP localport=#{node['nagios_client']['check_nsca_port']}"
  returns [0,1,42] # *sigh* cmd.exe return codes are wonky
  not_if { Nagios::Helper.firewall_rule_enabled?(firewall_rule_name_check_nsca) }
end

execute "open-ping-port" do
  command "netsh firewall set icmpsetting 8 enable"
  returns [0,1,42] # *sigh* cmd.exe return codes are wonky
  not_if { Nagios::Helper.firewall_rule_enabled?("icmpsetting 8") }
end


template "#{home}/boot.ini" do
  source "boot.ini.erb"
  notifies :restart, "service[#{service_name}]", :immediately
end

template "#{home}/nsclient.ini" do
  source "nsclient.ini.erb"
  notifies :restart, "service[#{service_name}]", :immediately
end

service service_name do
  action :nothing
end

file dst do
  backup false
  action :nothing
end

