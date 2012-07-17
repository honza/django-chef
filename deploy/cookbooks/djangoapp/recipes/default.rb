execute "Update apt repos" do
    command "apt-get update"
end

package 'vim'

include_recipe 'nginx'
include_recipe 'build-essential'
include_recipe 'python'
include_recipe 'openssl'
include_recipe 'postgresql::server'
include_recipe 'memcached'
include_recipe 'runit'
include_recipe 'git'

execute "restart postgres" do
    command "sudo /etc/init.d/postgresql restart"
end

execute "create-database" do
    command "createdb -U postgres -O postgres #{node[:dbname]}"
end
