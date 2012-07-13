#
# Cookbook Name:: steelmesh
# Recipe:: default
#
# Copyright 2012, Sidelab Pty Ltd.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "git"

packages = value_for_platform(
    ["ubuntu"] => {'default' => ['redis-server']}
  )

packages.each do |devpkg|
  package devpkg
end

user node[:steelmesh][:user] do
  shell "/bin/bash"
  home "/home/#{node[:steelmesh][:user]}"
  action :create
end

group node[:steelmesh][:group] do
  members [node[:steelmesh][:user]]
  action :create
end

## Needed for ssh to skip the yes/no trust thing
cookbook_file "#{Chef::Config[:file_cache_path]}/wrap-ssh4git.sh" do
  source "wrap-ssh4git.sh"
  mode 0700
end

directory node[:steelmesh][:dir] do
  owner node[:steelmesh][:user]
  group node[:steelmesh][:group]
  action :create
end

git node[:steelmesh][:dir] do
  user node[:steelmesh][:user]
  group node[:steelmesh][:group]
  repository "git://github.com/steelmesh/steelmesh.git"
  reference "master"
  action :checkout
  ssh_wrapper "#{Chef::Config[:file_cache_path]}/wrap-ssh4git.sh"
end 

directory "#{node[:steelmesh][:dir]}/logs" do
  owner node[:steelmesh][:user]
  group node[:steelmesh][:group]
  action :create
end

## Npm can only be run as root
script "install_node_modules" do
  interpreter "bash"
  cwd node[:steelmesh][:dir]
  not_if "test -d #{node[:steelmesh][:dir]}/node_modules"
  code <<-EOH
  npm install
  chown -R #{node[:steelmesh][:user]}:#{node[:steelmesh][:group]} node_modules/
  EOH
end

if platform?("ubuntu")
  template "/etc/init/steelmesh.conf" do
    source "steelmesh-upstart.conf.erb"
    owner "root"
    group "root"
    mode "0755"
  end

  service "steelmesh" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true
    action [ :enable, :start ]
  end
end

if platform?("centos", "rhel")
  template "/etc/init.d/steelmesh" do
    source "steelmesh.init.erb"
    owner "root"
    group "root"
    mode "0755"
  end

  template node[:steelmesh][:init_conf] do
    source "steelmesh.conf.erb"
    owner "root"
    group "root"
    mode "0644"
  end

  service "steelmesh" do
    supports :status => true, :restart => true
    action [ :enable, :start ]
  end
end
