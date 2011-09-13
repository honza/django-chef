package "postgresql" do
    :upgrade
end

service "postgresql-8.4" do
  enabled true
  running true
  supports :status => true, :restart => true
  action [:enable, :start]
end

cookbook_file "/etc/postgresql/8.4/main/pg_hba.conf" do
    source "pg_hba.conf"
    mode 0755
    notifies :restart, resources(:service => "postgresql-8.4")
end

# Create a db user and a db
include_recipe "postgresql"

# https://gist.github.com/637579

execute "restart postgres" do
    command "sudo /etc/init.d/postgresql-8.4 restart"
end

execute "create-root-user" do
    command "createuser -U postgres -s root"
end

execute "create-database-user" do
    command "createuser -U postgres -sw directory"
end

execute "create-database" do
    #command "createdb -U postgres -O #{node[:dbuser]} -E utf8 -T template0 #{node[:dbname]}"
    command "createdb -U directory -O directory directory"
end
