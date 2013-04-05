node.set[:redis][:slaveof] = search(:node, 'chef_environment:#{node.chef_environment} AND recipes:redis::master').first.first.ec2.local_hostname

include_recipe "redis::source"
