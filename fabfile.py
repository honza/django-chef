from fabric.api import cd, env, prefix, run, sudo, local, settings
from contextlib import contextmanager


env.roledefs = {
    'vagrant': ['vagrant@127.0.0.1:2222']
}

env.root_dir = '/var/www/nginx-default'
env.virtualenv = '%s/env' % env.root_dir
env.activate = 'source %s/bin/activate ' % env.virtualenv
env.code_dir = '%s/coolname' % env.root_dir
env.media_dir = '%s/media' % env.root_dir

env.chef_executable = '/var/lib/gems/1.8/bin/chef-solo'


@contextmanager
def _virtualenv():
    with prefix(env.activate):
        yield


def _vagrant():
    result = local('vagrant ssh_config | grep IdentityFile', capture=True)
    env.key_filename = result.split()[1]


def create_virtualenv():
    with cd(env.root_dir):
        sudo('virtualenv env --no-site-packages')


def install_chef():
    """
    Install chef-solo on the server
    """
    sudo('apt-get update', pty=True)
    sudo('apt-get install -y git-core rubygems ruby ruby-dev', pty=True)
    sudo('gem install chef --no-ri --no-rdoc', pty=True)


def sync_config():
    """
    rsync `deploy/` to the server
    """
    local('rsync -av deploy/ %s@%s:/etc/chef' % (env.user, env.hosts[0]))


def provision():
    """
    Run chef-solo
    """
    sync_config()
    sudo('cd /etc/chef && %s -c solo.rb -j node.json' % env.chef_executable, pty=True)


def restart():
    """
    Reload nginx/gunicorn
    """
    if env.user == 'vagrant':
        _vagrant()
    with settings(warn_only=True):
        with cd(env.code_dir):
            pid = sudo('cat gunicorn.pid')
            sudo('find . -name "*.pyc" -exec rm {} \;')
            if not pid.succeeded:
                start_gunicorn()
            else:
                sudo('kill -HUP %s' % pid)
    sudo('/etc/init.d/nginx restart')


def start_gunicorn():
    if env.user == 'vagrant':
        _vagrant()
    with cd(env.code_dir):
        with _virtualenv():
            if env.user == 'vagrant':
                sudo('gunicorn_django -c gunicorn.py --daemon settings_server.py & sleep 3')
            else:
                sudo('gunicorn_django -c gunicorn-vagrant.py --daemon settings_server.py & sleep 3')


def push():
    """
    Update application code on the server
    """
    if env.user == 'vagrant':
        # Check if a link between /vagrant and /var/www exists
        # If not, create it
        _vagrant()
        with settings(warn_only=True):
            result = sudo('ls %s' % env.code_dir)
            if not result.succeeded:
                sudo('ln -s /vagrant/coolname %s' % env.code_dir)
            result = sudo('ls %s' % env.media_dir)
            if not result.succeeded:
                sudo('ln -s /vagrant/media %s' % env.media_dir)

        return

    with settings(warn_only=True):
        result = local("git push live dev")

        # if push didn't work, the repository probably doesn't exist
        # 1. create an empty repo
        # 2. push to it with -u
        # 3. retry
        # 4. profit

        if not result.succeeded:
            result2 = run("ls %s" % env.code_dir)
            if not result2.succeeded:
                sudo('mkdir %s' % env.code_dir)
            with cd("%s" % env.code_dir):
                sudo("git init")
                sudo("git config --bool receive.denyCurrentBranch false")
                local("git push live -u dev")
                push()
                return

    with cd("%s" % env.code_dir):
        run('git checkout dev')


def bootstrap():
    """
    Init django project
    """
    push()
    create_virtualenv()
    with cd(env.code_dir):
        with _virtualenv():
            sudo('pip install -r ../deploy_requirements.txt', pty=True)
            sudo('python manage.py syncdb --noinput --settings=settings_server', pty=True)
            #sudo('python manage.py migrate --settings=settings_server', pty=True)
    restart()


def deploy():
    """
    Push code, sync, migrate, generate media, restart
    """
    push()
    with cd(env.code_dir):
        with _virtualenv():
            sudo('python manage.py syncdb --noinput --settings=settings_server', pty=True)
            #sudo('python manage.py migrate --settings=settings_server', pty=True)
            sudo('python manage.py collectstatic --settings=settings_server', pty=True)

# Local tasks
def clean():
    """
    Remove all .pyc files
    """
    local('find . -name "*.pyc" -exec rm {} \;')

def debug():
    """
    Find files with debug symbols
    """
    clean()
    local('grep -ir "print" *')
    local('grep -ir "console.log" *')

def todo():
    """
    Find all TODO and XXX
    """
    clean()
    local('grep -ir "TODO" *')
    local('grep -ir "XXX" *')
