#
# Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: couchdb
# Attributes:: couchdb
#
# Copyright 2010, Opscode, Inc
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

default['couch']['src_version'] = '1.2.0'
default['couch']['src_mirror']  = "http://mirror.overthewire.com.au/pub/apache/couchdb/releases/#{node[:couch][:src_version]}/apache-couchdb-#{node[:couch][:src_version]}.tar.gz"

default['couch']['git']         = 'git://github.com/apache/couchdb.git'

default['couch']['dir']         = '/opt/couchdb'
default['couch']['user']        = 'couchdb'
default['couch']['group']       = 'couchdb'

default['couch']['init']        = "#{node[:couch][:dir]}/etc/init.d/couchdb"
default['couch']['logrotate']   = "#{node[:couch][:dir]}/etc/logrotate.d/couchdb"

default['couch']['admin']       = 'admin'
default['couch']['password']    = 'password'

default['couch']['listen']      = '0.0.0.0'