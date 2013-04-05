case node[:redis][:init]
when "init"
  template "/etc/init.d/redis" do
    cookbook "redis"
    source "redis.sysv.erb"
    mode 0755
    backup false
  end
when "upstart"
  template "/etc/init/redis.conf" do
    cookbook "redis"
    source "redis.upstart.erb"
    mode 0644
    backup false
  end
end
