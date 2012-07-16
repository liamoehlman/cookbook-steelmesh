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

include_recipe "erlang"
include_recipe "build-essential"

packages = value_for_platform(
  ["ubuntu"] => {'default' => ['libmozjs-dev', 'libicu-dev', 'libcurl4-gnutls-dev', 'libtool']}
)

packages.each do |devpkg|
  package devpkg
end

compile_flags = "--prefix=#{node[:couch][:dir]}"

user node[:couch][:user] do
  home node[:couch][:dir]
  comment "CouchDB Administrator"
  supports :manage_home => false
  system true
  action :create
end

group node[:couch][:group] do
  group_name node[:couch][:group]
  members  node[:couch][:user]
  action :create
end

directory node[:couch][:dir] do
  owner node[:couch][:user]
  group node[:couch][:group]
  mode "0755"
  action :create
end

case node[:couch][:version]
when "latest"
  include_recipe "git"

  couchdb_tar_gz = File.join(Chef::Config[:file_cache_path], "/", "apache-couchdb-#{node[:couch][:version]}")
  ## Include the wrapper file for git so the run doesn't hang on the yes/no ssh accept
  cookbook_file "#{Chef::Config[:file_cache_path]}/wrap-ssh4git.sh" do
    source "wrap-ssh4git.sh"
    mode 0700
  end

  git couchdb_tar_gz do
    repository "git://github.com/apache/couchdb.git"
    reference "master"
    action :sync
    ssh_wrapper "#{Chef::Config[:file_cache_path]}/wrap-ssh4git.sh"
  end

## Copy over the init scripts created when couchdb installs
  bash "install_couchdb_git" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      cd apache-couchdb-#{node[:couch][:version]} && ./bootstrap && ./configure #{compile_flags} && make && make install
      chown -R #{node[:couch][:user]}:#{node[:couch][:group]} #{node[:couch][:dir]}
      cp -R #{node[:couch][:init]} /etc/init.d/couchdb
      cp -R #{node[:couch][:logrotate]} /etc/logrotate.d/couchdb
    EOH
    creates "#{node[:couch][:dir]}/bin/couchdb"
    creates "/etc/init.d/couchdb"
    creates "/etc/logrotate.d/couchdb"
  end    

else 
  couchdb_tar_gz = File.join(Chef::Config[:file_cache_path], "/", "apache-couchdb-#{node[:couch][:version]}.tar.gz")

  remote_file couchdb_tar_gz do
  source node[:couch][:src_mirror]
  end

  bash "install couchdb" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      tar -zxf #{couchdb_tar_gz}
      cd apache-couchdb-#{node[:couch][:version]} && ./configure #{compile_flags} && make && make install
      chown -R #{node[:couch][:user]}:#{node[:couch][:group]} #{node[:couch][:dir]}
      cp -R #{node[:couch][:init]} /etc/init.d/couchdb
      cp -R #{node[:couch][:logrotate]} /etc/logrotate.d/couchdb
    EOH
    creates "#{node[:couch][:dir]}/bin/couchdb"
    creates "/etc/init.d/couchdb"
    creates "/etc/logrotate.d/couchdb"
  end
end

template "#{node[:couch][:dir]}/etc/couchdb/local.ini" do
  owner node[:couch][:user]
  group node[:couch][:group]
  source "local.ini.erb"
  action :create
end 

service "couchdb" do
  supports [:restart, :status]
  action [:enable, :start]
end

