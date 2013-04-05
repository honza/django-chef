## Latest stable Redis, built from source.

### Tested only on Ubuntu, 10.04.3, 64bit.

If you've been using this cookbook in the past, there are some important
changes that you should take into account before upgrading to the latest
version

1. I'm now using a separate versioning, no longer sticking to the redis one. If
   the previous cookbook version was 2.4.2 (redis version), this one is 2.0.0.

2. I made some changes in how configs and restarts are being handled, an
   upgrade from a previous version will **not** be seamless. The 2.0.0 is the
hint.

3. I only make the important settings configurable via the cookbook's
   attributes. The ones which I don't personally use, I've left out. Feel free
to fork the cookbook, add your own and submit a pull request.

4. All config values are heavily documented. Open up the attributes file and
   you'll see what I mean. They were taken directly from the official redis
repository, version 2.4.16.

5. Redis is now configured so that by default it doesn't persist the data to
   disk. Before, snapshotting was turned on by default.  Just to make this
clear, **the snapshotting and appendfile are turned off by default**. If you
need these options, configure them via role attributes.

6. The redis user **is** given a shell: `/bin/sh`. Previously, this has been
   set to `/bin/false`. Not sure if this is the best approach, but this enables
upstart jobs via `su - redis -c 'some-command'`.
