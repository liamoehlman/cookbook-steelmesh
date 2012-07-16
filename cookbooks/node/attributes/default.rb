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

default[:node][:version]    = "0.6.13"
default[:node][:binary]     = "/usr/local/bin/node"