#
# Author:: Liam Oehlman <liam.oehlman@sidelab.com>
# Cookbook Name:: couchdb
# Recipe:: source
#
# Copyright 2012, Sidelab Pty Ltd
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
