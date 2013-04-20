default[:nagios_client][:dir] = "C:\\"
default[:nagios_client][:mirror] = "http://files.nsclient.org/0.4.0"
default[:nagios_client][:msi] = "NSCP-0.4.0.183-x64.msi"
default[:nagios_client][:instance_name] = "NSClient++"

# Section for NSClient (NSClientServer.dll) (check_nt) protocol options.
default[:nagios_client][:check_nt_port] = "12489"               #Port to use for check_nt.
default[:nagios_client][:send_perf_data_nt] = "true"    		#Send performance data back to nagios (set this to 0 to remove all performance data)

# NRPE
default[:nagios_client][:check_nrpe_port] = "5666"              #Port to use for NRPE.
default[:nagios_client][:timeout_nrpe] = "30"                   #Timeout when reading/writing packets to/from sockets.
default[:nagios_client][:use_ssl] = "true"                      #This option controls if SSL should be enabled.

# NSCA
default[:nagios_client][:check_nsca_port] = "5667"              #Port to use for NSCA.
default[:nagios_client][:send_perf_data_nsca] = "true"  		#Send performance data back to nagios (set this to 0 to remove all performance data)

#SMTP
default[:nagios_client][:timeout_nsca] = "30"                   #Timeout when reading/writing packets to/from sockets.

#eventlog
default[:nagios_client][:event_log][:buffer_size] = 131072      #The size of the buffer to use when getting messages this affects the speed and maximum size of messages you can recieve.
default[:nagios_client][:event_log][:debug] = "true"            #Log more information when filtering (usefull to detect issues with filters) not usefull in production as it is a bit of a resource hog.
default[:nagios_client][:event_log][:lookup_names] = "true"     #Lookup the names of eventlog files
default[:nagios_client][:event_log][:syntax] = ""               #Set this to use a specific syntax string for all commands (that don't specify one).