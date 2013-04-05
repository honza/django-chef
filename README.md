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

Todo
----

* RabbitMQ + celery

License
-------

BSD, short and sweet
