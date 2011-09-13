from fabric.api import env, local, run, sudo, cd, prefix
from contextlib import contextmanager
env.user = 'vagrant'
env.hosts = ['127.0.0.1:2222']

env.code_dir = '/home/yoyoyo/sites/yoyoyo/checkouts/yoyoyo'
env.virtualenv = '/home/yoyoyo/sites/yoyoyo'
env.rundir = '/home/yoyoyo/sites/yoyoyo/run'
env.activate = 'source %s/bin/activate' % env.virtualenv

env.chef_executable = '/var/lib/gems/1.8/bin/chef-solo'


def vagrant():
    result = local('vagrant ssh_config | grep IdentityFile', capture=True)
    env.key_filename = result.split()[1]

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
    env.user = "yoyoyo"
    run("kill -HUP `cat %s/gunicorn.pid`" % env.rundir, pty=True)

@contextmanager
def _virtualenv():
    with prefix(env.activate):
        yield

def bootstrap():
    with cd("%s/yoyoyo" % env.code_dir):
        with _virtualenv():
            run('python manage.py syncdb --noinput --settings=settings_server')
            run('python manage.py migrate --settings=settings_server')
