#log_level :info
#cookbook_path "/etc/chef/cookbooks"
#json_attribs "/etc/chef/node.json"
#role_path "/etc/chef/roles"
root = File.absolute_path(File.dirname(__FILE__))
 
file_cache_path root
cookbook_path root + '/cookbooks'
