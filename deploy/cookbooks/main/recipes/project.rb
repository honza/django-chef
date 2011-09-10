cookbook_file "/home/project/.bash_profile" do
    source "bash_profile"
    owner "project"
    group "project"
    mode 0755
end

directory "/home/project/.ssh" do
    owner "project"
    group "project"
    mode 0700
end

#This is currently broken :(
if node.attribute?('private_key')
    file = File.open(node[:private_key], "rb")
    file_contents = file.read
    file "/home/project/.ssh/id_rsa" do
        owner "project"
        group "project"
        mode 0600
        content file_contents
    end
end

directory "/home/project/sites/" do
    owner "project"
    group "project"
    mode 0775
end

virtualenv "/home/project/sites/project" do
    owner "project"
    group "project"
    mode 0775
end

directory "/home/project/sites/project/run" do
    owner "project"
    group "project"
    mode 0775
end

directory "/home/project/sites/project/checkouts" do
    owner "project"
    group "project"
    mode 0775
end

#git "/home/project/sites/project/checkouts/project" do
  #repository "git://github.com/rtfd/project.git"
  #reference "HEAD"
  #user "project"
  #group "project"
  #action :sync
#end

execute "This next part installs all the requirements. It will take a while." do
    command "echo 'wee'"
end

script "Install Requirements" do
  interpreter "bash"
  user "project"
  group "project"
  code <<-EOH
  /home/project/sites/project/bin/pip install -r /home/project/sites/project/checkouts/project/deploy_requirements.txt
  touch /tmp/pip_ran
  EOH
  creates "/tmp/pip_ran"
end
