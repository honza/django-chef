# Gunicorn setup

cookbook_file "/etc/init/yoyoyo-gunicorn.conf" do
    source "gunicorn.conf"
    owner "root"
    group "root"
    mode 0644
    notifies :restart, "service[yoyoyo-gunicorn]"
end

service "yoyoyo-gunicorn" do
    provider Chef::Provider::Service::Upstart
    enabled true
    running true
    supports :restart => true, :reload => true, :status => true
    action [:enable, :start]
end
