cookbook_file "/etc/init/project-celery.conf" do
    source "celery.conf"
    owner "root"
    group "root"
    mode 0644
    notifies :restart, "service[project-celery]"
end

service "project-celery" do
    provider Chef::Provider::Service::Upstart
    enabled true
    running true
    supports :restart => true, :reload => true, :status => true
    action [:enable, :start]
end
