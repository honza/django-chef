#
# Author:: Noah Kantrowitz <noah@opscode.com>
# Cookbook Name:: supervisor
# Provider:: service
#
# Copyright:: 2011, Opscode, Inc <legal@opscode.com>
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

action :enable do
  execute "supervisorctl update" do
    action :nothing
    user "root"
  end

  template "#{node['supervisor']['dir']}/#{new_resource.service_name}.conf" do
    source "program.conf.erb"
    cookbook "supervisor"
    owner "root"
    group "root"
    mode "644"
    variables :prog => new_resource
    notifies :run, resources(:execute => "supervisorctl update"), :immediately
  end
end

action :disable do
  execute "supervisorctl update" do
    action :nothing
    user "root"
  end

  file "#{node['supervisor']['dir']}/#{new_resource.service_name}.conf" do
    action :delete
    notifies :run, resources(:execute => "supervisorctl update"), :immediately
  end
end

action :start do
  execute "supervisorctl start #{cmd_line_args}" do
    user "root"
  end
end

action :stop do
  execute "supervisorctl stop #{cmd_line_args}" do
    user "root"
  end
end

action :restart  do
  execute "supervisorctl restart #{cmd_line_args}" do
    user "root"
  end
end

action :reload  do
  execute "supervisorctl restart #{cmd_line_args}" do
    user "root"
  end
end

def cmd_line_args
  name = new_resource.service_name
  if new_resource.numprocs > 1
    name += ':*'
  end
  name
end
