from fabric.api import env, local, run, sudo
env.user = 'root'
env.hosts = ['1.1.1.1']

env.code_dir = '/home/project/sites/project/checkouts/project'
env.virtualenv = '/home/project/sites/project'
env.rundir = '/home/project/sites/project/run'

env.chef_executable = '/var/lib/gems/1.8/bin/chef-solo'


def install_chef():
    sudo('apt-get update', pty=True)
    sudo('apt-get install -y git-core rubygems ruby ruby-dev', pty=True)
    sudo('gem install chef --no-ri --no-rdoc', pty=True)

def sync_config():
    local('rsync -av . %s@%s:/etc/chef' % (env.user, env.hosts[0]))

def update():
    sync_config()
    sudo('cd /etc/chef && %s' % env.chef_executable, pty=True)

def reload():
    "Reload the server."
    env.user = "project"
    run("kill -HUP `cat %s/gunicorn.pid`" % env.rundir, pty=True)

def restart():
    "Restart (or just start) the server"
    sudo('restart project-gunicorn', pty=True)
