default[:steelmesh][:user]      = "steelmesh"
default[:steelmesh][:group]     = "steelmesh"
default[:steelmesh][:dir]       = "/usr/local/steelmesh"
default[:steelmesh][:log]       = "#{node[:steelmesh][:dir]}/logs/steelmesh.log"

case platform
when "ubuntu"
  default[:steelmesh][:init_conf] = "/etc/default/steelmesh"

when "centos, rhel"
  default[:steelmesh][:init_conf] = "/etc/sysconfig/steelmesh"
end