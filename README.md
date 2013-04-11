django-chef
===========

django-chef is a project that will help you provision a server for your Django
app.  It will install all the pieces of a modern web application and give you
the tools to deploy with a single command.

You can use this project as a starting point.  It includes a vagrant
configuration which allows you to test your configuration and develop inside
the same environment that you would in production.

Quick start
-----------

    $ git clone git://github.com/honza/django-chef.git
    $ cd django-chef
    # add yourself to the "users" array in the Vagrantfile
    $ sudo echo "127.0.0.1 example.example.com" >> /etc/hosts
    $ vagrant up
    $ fab vagrant:honza bootstrap  # replace with your name
    $ vagrant ssh
    $ run

Then open your browser to http://example.example.com:3456.

What it installs
----------------

* nginx
* postgresql
* redis
* git

How it works
------------

Your django project goes into the `src/` directory.  Right now it includes a
simple bare-bones project.  You should place your files there.

The name of your application is assumed to be `example`.  It's used throughout.

You can then use the included Chef cookbooks to provision a local VM.

It will install your application into `/opt/example`.  The structure of that
directory is something like this

    /opt/example
        /apps
            /example
                # Your Django project here
        /venvs
            /example

Each developer on your team should be added to the `users` list in the
`Vagrantfile` and the `node` file so that they can access the server.

Developing
----------

If you want to develop in vagrant, it's as simple as provisioning the VM,
logging in and typing in `run`.  Instead of using supervisor to daemonize the
gunicorn process that servers your Django application, you will use Django's
built-in server.  This is great because it will reload your application when it
detects changes to the source code.

To facilitate this, there is a bit of special stuff in the nginx directive.
But that's it.  Everything else is the same as it would be in production.

When developing, you don't need to commit your changes in order to see if a bug
was fixed.  This project takes advantage of vagrant's shared folders. The
source code on the host machine is symlinked to the `/opt` directory.

Deployment
----------

Deploying is as easy as issue ia single Fabric command.

    $ fab vagrant:honza deploy
    # or
    $ fab staging:honza deploy

Deployments are based around git.  When you deploy, the script will run `git
push` to your server so make sure your local changes are committed before
deploying.  Deploying with git is useful because the server knows which
revision is currently live.

Todo
----

* RabbitMQ + celery
* Install patched postgresql

License
-------

BSD, short and sweet
