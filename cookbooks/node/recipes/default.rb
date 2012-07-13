#
# Cookbook Name:: node
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "build-essential"

node_version = node[:node][:version]

case node[:platform]
  when "centos","redhat","fedora"
    package "openssl-devel"
  when "debian","ubuntu"
    package "libssl-dev"
end

remote_file "#{Chef::Config[:file_cache_path]}/node-v#{node_version}.tar.gz" do
  source "http://nodejs.org/dist/v#{node_version}/node-v#{node_version}.tar.gz"
  action :create_if_missing
end

bash "compile_node_source" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxf node-v#{node_version}.tar.gz
    cd node-v#{node_version} && ./configure
    make && make install
  EOH
  creates node[:node][:binary]
end