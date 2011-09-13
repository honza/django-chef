cookbook_file "/home/yoyoyo/.bash_profile" do
    source "bash_profile"
    owner "yoyoyo"
    group "yoyoyo"
    mode 0755
end

directory "/home/yoyoyo/.ssh" do
    owner "yoyoyo"
    group "yoyoyo"
    mode 0700
end

#This is currently broken :(
if node.attribute?('private_key')
    file = File.open(node[:private_key], "rb")
    file_contents = file.read
    file "/home/yoyoyo/.ssh/id_rsa" do
        owner "yoyoyo"
        group "yoyoyo"
        mode 0600
        content file_contents
    end
end

directory "/home/yoyoyo/sites/" do
    owner "yoyoyo"
    group "yoyoyo"
    mode 0775
end

virtualenv "/home/yoyoyo/sites/yoyoyo" do
    owner "yoyoyo"
    group "yoyoyo"
    mode 0775
end

directory "/home/yoyoyo/sites/yoyoyo/run" do
    owner "yoyoyo"
    group "yoyoyo"
    mode 0775
end

directory "/home/yoyoyo/sites/yoyoyo/checkouts" do
    owner "yoyoyo"
    group "yoyoyo"
    mode 0775
end

#git "/home/yoyoyo/sites/yoyoyo/checkouts/yoyoyo" do
  #repository "git://github.com/rtfd/yoyoyo.git"
  #reference "HEAD"
  #user "yoyoyo"
  #group "yoyoyo"
  #action :sync
#end

execute "This next part installs all the requirements. It will take a while." do
    command "echo 'wee'"
end

script "Install Requirements" do
  interpreter "bash"
  user "yoyoyo"
  group "yoyoyo"
  code <<-EOH
  /home/yoyoyo/sites/yoyoyo/bin/pip install -r /home/yoyoyo/sites/yoyoyo/checkouts/yoyoyo/deploy_requirements.txt
  touch /tmp/pip_ran
  EOH
  creates "/tmp/pip_ran"
end
