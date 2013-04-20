#
# Author:: Joshua Sierles <joshua@37signals.com>
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Nathan Haneysmith <nathan@opscode.com>
# Cookbook Name:: nagios
# Recipe:: client
#
# Copyright 2009, 37signals
# Copyright 2009-2010, Opscode, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "nagios::default"
mon_host = Array.new

if node.run_list.roles.include?(node[:nagios][:server_role])
  mon_host << node[:ipaddress]
else
  search(:node, "roles:#{node[:nagios][:server_role]} AND app_environment:#{node[:app_environment]}") do |n|
    mon_host << n['ipaddress']
  end
end

## without apt-get update following error sometimes shows up (Ubuntu 10.04):
#...
#apt-get -q -y install nagios-nrpe-server=2.12-4ubuntu1 returned 100, expected 0
#...
#After this operation, 72.6MB of additional disk space will be used.
#Err http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ lucid-updates/main mysql-common 5.1.41-3ubuntu12.9
#  404  Not Found [IP: 10.210.205.172 80]
#Err http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ lucid-updates/main libmysqlclient16 5.1.41-3ubuntu12.9
#  404  Not Found [IP: 10.210.205.172 80]STDERR: Failed to fetch http://us-east-1.ec2.archive.ubuntu.com/ubuntu/pool/main/m/mysql-dfsg-5.1/mysql-common_5.1.41-3ubuntu12.9_all.deb  404  Not Found [IP: 10.210.205.172 80]
#Failed to fetch http://us-east-1.ec2.archive.ubuntu.com/ubuntu/pool/main/m/mysql-dfsg-5.1/libmysqlclient16_5.1.41-3ubuntu12.9_amd64.deb  404  Not Found [IP: 10.210.205.172 80]
#E: Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?
#...

e = execute "apt-get update" do
  action :nothing
end

e.run_action(:run)


%w{
  nagios-nrpe-server
  nagios-plugins
  nagios-plugins-basic
  nagios-plugins-standard
}.each do |pkg|
  package pkg
end

service "nagios-nrpe-server" do
  action :enable
  supports :restart => true, :reload => true
end

remote_directory "/usr/lib/nagios/plugins" do
  source "plugins"
  owner "nagios"
  group "nagios"
  mode 0755
  files_mode 0755
end

template "/etc/nagios/nrpe.cfg" do
  source "nrpe.cfg.erb"
  owner "nagios"
  group "nagios"
  mode "0644"
  variables :mon_host => mon_host
  notifies :restart, resources(:service => "nagios-nrpe-server")
end
