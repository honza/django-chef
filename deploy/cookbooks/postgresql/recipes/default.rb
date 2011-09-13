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
    code = <<-EOH
    psql -U postgres -c "select * from pg_user where usename='root'" | grep -c root
    EOH
    command "createuser -U postgres -s root"
    not_if code
end

execute "create-database-user" do
    code = <<-EOH
    psql -U postgres -c "select * from pg_user where usename='project'" | grep -c project
    EOH
    command "createuser -U postgres -sw project"
    not_if code
end

execute "create-database" do
    exists = <<-EOH
    psql -U postgres -c "select * from pg_database WHERE datname='project'" | grep -c project
    EOH
    command "createdb -U project -O project project"
    not_if exists
end
