#
# Cookbook Name:: devstack
# Recipe:: default
#
# Copyright 2012, Rackspace US, Inc.
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
#

include_recipe 'git'

directory "#{node['devstack']['dest']}" do
  owner "root"
  group "root"
  mode 00755
  action :create
  recursive true
end

git "#{node['devstack']['dest']}/devstack" do
  repository "https://github.com/openstack-dev/devstack.git"
  reference "master"
end

template "localrc" do
   path "#{node['devstack']['dest']}/devstack/localrc"
   owner "root"
   group "root"
   mode 00644
end

directory "/root/.pip" do
  owner "root"
  group "root"
  mode 00644
  action :create
  recursive true
end

template "pip.conf" do
   path "/root/.pip/pip.conf"
   owner "root"
   group "root"
   mode 00644
end

execute "apt-get-update" do
  command "apt-get update"
end

execute "stack.sh" do
  command "./stack.sh > /var/log/devstack.log"
  cwd "#{node['devstack']['dest']}/devstack"
end
