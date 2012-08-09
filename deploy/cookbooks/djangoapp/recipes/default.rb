execute "clean it" do
    command "apt-get clean -y"
end

execute "update package index" do
    command "apt-get update"
    ignore_failure true
    action :nothing
end.run_action(:run)

# User, directories, etc -----------------------------------------------------

group "coolname" do
    gid 1337
end

user "coolname" do
    username "coolname"
    comment "Application User"
    gid 1337
    uid 1337
    shell "/bin/bash"
    home "/home/coolname"
end

directory "/home/coolname" do
    owner "coolname"
    group "coolname"
    mode 0755
end

directory "/home/coolname/media" do
    owner "coolname"
    group "coolname"
    mode 0755
end

directory "/home/coolname/media/uploads" do
    owner "coolname"
    group "coolname"
    mode 0755
end

directory "/home/coolname/static" do
    owner "coolname"
    group "coolname"
    mode 0755
end

group "sudoers" do
    members ["coolname"]
end

directory "/home/coolname/.ssh" do
    owner "coolname"
    group "coolname"
    mode 0700
end

cookbook_file "/home/coolname/.ssh/authorized_keys" do
    source "authorized_keys"
    owner "coolname"
    group "coolname"
    mode 0600
end

# Packages -------------------------------------------------------------------
#

package 'vim'
package 'python-software-properties'

execute "add nginx ppa" do
    command "sudo add-apt-repository ppa:nginx/stable"
end

include_recipe 'nginx'
include_recipe 'build-essential'
include_recipe 'python'
include_recipe 'openssl'
include_recipe 'memcached'
include_recipe 'runit'
include_recipe 'git'
include_recipe 'apt'
include_recipe "postgresql::server"

execute "restart postgres" do
    command "sudo /etc/init.d/postgresql restart"
end

execute "create-database" do
    command "createdb -U postgres -O postgres #{node[:dbname]}"
end
