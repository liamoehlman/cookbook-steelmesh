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