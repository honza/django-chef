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

Of course, other small applications will be installed to ensure smoother
execution:

* virtualenv & pip
* git/hg
* Python driver for postgresql
* etc

This is a work in progress. I'd welcome any suggestions or help.

Usage
-----

* Install [Vagrant][3]
* Download the `lucid64` box and add it as `base`
* Move your project to the `project` directory
* Seach and replace all occurrences of `yoyoyo` with your project's name
    * `$ find . -path './.git' -prune -o -type f -print0 | xargs -0 sed -i '' 's/yoyoyo/yourname/g'`
* `cd` into the `deploy` directory
* Run `vagrant up`
* Once it's done, run `vagrant halt` and then `vagrant up` again
* Lastly, bootstrap your django project with `fab vagrant bootstrap` (requires fabric)

Credit
------

Most of this code is stolen/borrowed from the amazing [Read The Docs][5] project.

[1]: https://www.djangoproject.com/
[2]: http://www.opscode.com/chef/
[3]: http://vagrantup.com/
[4]: http://djangocon.us/
[5]: https://github.com/rtfd/readthedocs.org
