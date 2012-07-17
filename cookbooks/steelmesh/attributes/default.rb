#
# Author:: Liam Oehlman <liam.oehlman@sidelab.com>
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