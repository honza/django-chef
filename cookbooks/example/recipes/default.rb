# example recipe
# ============

execute "clean it" do
    command "apt-get clean -y"
end

execute "update package index" do
    command "apt-get update"
end

group "deploy" do
    gid 123
end

if node[:user] == "vagrant"

    user "vagrant" do
        group "deploy"
    end

    template "/home/vagrant/.bashrc" do
        source "bashrc.erb"
        owner "vagrant"
    end

end

node[:users].each do |u|
    user u[:name] do
        username u[:name]
        shell "/bin/bash"
        home "/home/#{u[:name]}"
        group "deploy"
    end

    directory "/home/#{u[:name]}" do
        owner u[:name]
        group "deploy"
        mode 0700
    end

    directory "/home/#{u[:name]}/.ssh" do
        owner u[:name]
        group "deploy"
        mode 0700
    end

    template "/home/#{u[:name]}/.bashrc" do
        source "bashrc.erb"
        owner u[:name]
        mode 0700
    end

    cookbook_file "/home/#{u[:name]}/.profile" do
        source "profile"
        owner u[:name]
        mode 0700
    end

    execute "authorized keys" do
        command "echo #{u[:key]} > /home/#{u[:name]}/.ssh/authorized_keys"
    end
end

cookbook_file "/etc/sudoers" do
    source "sudoers"
    mode 0440
end

directory "/opt/example" do
    owner "www-data"
    group "deploy"
    mode 0770
end

directory "/opt/example/apps" do
    owner "www-data"
    group "deploy"
    mode 0770
end

directory "/opt/example/apps/example" do
    owner "www-data"
    group "deploy"
    mode 0770
end

directory "/opt/example/apps/example/media" do
    owner "www-data"
    group "deploy"
    mode 0770
end

directory "/opt/example/apps/example/static" do
    owner "www-data"
    group "deploy"
    mode 0770
end

directory "/opt/example/venvs" do
    owner "www-data"
    group "deploy"
    mode 0770
end

# ssh  ------------------------------------------------------------------------

cookbook_file "/etc/ssh/sshd_config" do
    source "sshd_config"
end

execute "restart ssh" do
    command "service ssh restart"
end

package "vim"
package "python-software-properties"
package "ntp"
package "curl"
package "htop"
package "mosh"

# PIL dependencies
package "libjpeg8"
package "libjpeg-dev"
package "libfreetype6"
package "libfreetype6-dev"
package "zlib1g-dev"

include_recipe "openssl"
include_recipe "build-essential"
include_recipe "git"
include_recipe "python"
include_recipe "apt"
include_recipe "nginx"
include_recipe "postgresql::server"
include_recipe "supervisor"
include_recipe "redis"

template "/etc/supervisor.d/app.conf" do
    source "app.conf.erb"
end

service "supervisor" do
    action :stop
end

service "supervisor" do
    action :start
end

cookbook_file "/etc/postgresql/#{node[:postgresql][:version]}/main/pg_hba.conf" do
    source "pg_hba.conf"
    owner "postgres"
end

execute "restart postgres" do
    command "sudo /etc/init.d/postgresql restart"
end

execute "create database" do
    command "createdb -U postgres -T template0 -O postgres #{node[:dbname]} -E UTF8 --locale=en_US.UTF-8"
    not_if "psql -U postgres --list | grep #{node[:dbname]}"
end

python_virtualenv "/opt/example/venvs/example" do
    action :create
    group "deploy"
    if node[:user] == "vagrant"
        owner "vagrant"
    else
        owner "www-data"
    end
end
