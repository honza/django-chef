django-chef
===========

This is meant to be a blank [django][1] project template that uses [Chef][2] to
provision the server where your application will be deployed. It also uses
[Vagrant][3] to create the same environment in a Virtualbox VM.

I have made some choices as to how the django application will be deployed.
This is based on the content and recommendations stemming from [Djangocon
2011][4]. The following will be installed.

* Ubuntu server
* nginx
* gunicorn
* postgresql
* memcached
* rabbitmq
* celery

Of course, other small applications will be installed to ensure smoother
execution:

* virtualenv & pip
* git
* Python driver for postgresql
* etc


Usage
-----

* Install [Vagrant][3]
* Download the `precise32` box and add it as `precise32`
* Your django project should live in `coolname`. (i.e. `coolname/settings.py`)
* Add `coolname` (or what you change it to) to `/etc/hosts`
* Please change the name of the directory to match your project
* The name of the project has to be changed in a few other places
    * `fabfile.py`
    * `node.json`
* Run `vagrant up` to build the VM
* Run `vagrant ssh` and add the `coolname` user to `sudoers`
* Then run `fab -R vagrant bootstrap` which will create a virtualenv, load your
  code, install dependencies, sync your db, etc.
* Open your browser at `http://coolname:8844`.


Vagrant roledef for fabric
--------------------------

The main `fabfile` includes some special logic to work around some of the
limitations of vagrant. Nothing too hacky though. Every time you want to
execute something on your local VM, include the `-R vagrant` flag.


Root password
-------------

You can change the password in the `djangoapp/recipes/default.rb` file.  Find
the `user` block and change the value of the `password` attribute.  It should
be a salted hash, not plaintext.  To create a new password, run:

    $ openssl passwd -1 "theplaintextpassword"

And paste the result into the recipe file.

The password for the `coolname` user is `coolname`.

TODO
----

* Fix the fabfile
* Bring RabbitMQ back
* Add better Chef installation
* Test on real server (i.e. not Vagrant)

License
-------

BSD, short and sweet

Changelog
---------

* 0.5.0 (2012-07-17)
    - Upgrade to Ubuntu 12.04
    - Upgrade to postgresql 9.1
    - Upgrade to Python 2.7
    - Add vim package

* pre-0.5.0 (2012-07-16)
    - Distant past

[1]: https://www.djangoproject.com/
[2]: http://www.opscode.com/chef/
[3]: http://vagrantup.com/
[4]: http://djangocon.us/
