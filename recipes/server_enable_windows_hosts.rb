# Author:: Valeriu Craciun
# Cookbook Name:: nagios
# Recipe:: server_enable_windows_hosts

Chef::Log.info("Running nagios server configuration for windows clients...")

# Search all windows nodes (do it this way because fog's search doesn't return windows machines when filtering by  environment)
Chef::Log.info("Searching all windows instances in the '#{node[:app_environment]}' environment...")
windows_nodes = Array.new
windows_role_list = Array.new
search(:node, "*:*") do |n|
  if (n['platform'] == "windows" && n['app_environment'] == "#{node[:app_environment]}")
    Chef::Log.info(" NODE: #{n}  #{n['hostname']}  #{n['platform']}  #{n['platform_version']}  #{n['app_environment']}")
        windows_nodes << n
  end
end
Chef::Log.info("Windows Nodes: #{windows_nodes}")

nagios_conf "windows" do
  variables :nodes => windows_nodes
end
