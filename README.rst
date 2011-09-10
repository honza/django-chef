django-chef
===========

This is meant to be a blank `django`_ project template that uses `Chef`_ to
provision the server where your application will be deployed. It also uses
`Vagrant`_ to create the same environment in a Virtualbox VM.

I have made some choices as to how the django application will be deployed.
This is based on the content and recommendations stemming from `Djangocon
2011`_. The following will be installed.

* Ubuntu server
* nginx
* gunicorn
* postgresql
* memcached
* celery

Of course, other small applications will be installed to ensure smoother
execution:

* virtualenv & pip
* git/hg
* Python driver for postgresql
* etc

This is a work in progress. I'd welcome any suggestions or help.

Credit
------

Most of this code is stolen/borrowed from the amazing `Read The Docs`_ project.

.. _django: https://www.djangoproject.com/
.. _Chef: http://www.opscode.com/chef/
.. _Vagrant: http://vagrantup.com/
.. _DjangoCon 2011: http://djangocon.us/
.. _Read The Docs: https://github.com/rtfd/readthedocs.org
