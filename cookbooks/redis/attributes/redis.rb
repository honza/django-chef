default[:redis][:version]   = "2.6.12"
set[:redis][:dir]       = "redis-#{redis.version}"
set[:redis][:source]    = "http://redis.googlecode.com/files/#{redis.dir}.tar.gz"
default[:redis][:srcdir]    = "/usr/local/src"

default[:redis][:init]      = "upstart"
default[:redis][:config]    = "/etc/redis.conf"



# Note on units: when memory size is needed, it is possible to specifiy
# it in the usual form of 1k 5GB 4M and so forth:
#
# 1k => 1000 bytes
# 1kb => 1024 bytes
# 1m => 1000000 bytes
# 1mb => 1024*1024 bytes
# 1g => 1000000000 bytes
# 1gb => 1024*1024*1024 bytes
#
# units are case insensitive so 1GB 1Gb 1gB are all the same.



########################################################################### GENERAL
#
# When running daemonized, Redis writes a pid file in /var/run/redis.pid by
# default. You can specify a custom pid file location here.
default[:redis][:pidfile] = "/var/run/redis.pid"
#
# Accept connections on the specified port, default is 6379.
# If port 0 is specified Redis will not listen on a TCP socket.
default[:redis][:port] = 6379
#
# If you want you can bind a single interface, if the bind option is not
# specified all the interfaces will listen for incoming connections.
default[:redis][:bind] = false
#
# Specify the path for the unix socket that will be used to listen for
# incoming connections. There is no default, so Redis will not listen
# on a unix socket when not specified.
default[:redis][:unixsocket] = false
default[:redis][:unixsocketperm] = false
#
# Close the connection after a client is idle for N seconds (0 to disable)
default[:redis][:timeout] = 300
#
# Set server verbosity to 'debug'
# it can be one of:
# debug (a lot of information, useful for development/testing)
# verbose (many rarely useful info, but not a mess like the debug level)
# notice (moderately verbose, what you want in production probably)
# warning (only very important / critical messages are logged)
default[:redis][:loglevel] = "notice"

# Specify the log file name. Also 'stdout' can be used to force
# Redis to log on the standard output. Note that if you use standard
# output for logging but daemonize, logs will be sent to /dev/null
default[:redis][:logfile] = "/var/log/redis.log"
#
# To enable logging to the system logger, just set 'syslog-enabled' to yes,
# and optionally update the other syslog parameters to suit your needs.
default[:redis][:syslog_enabled] = false
#
# Specify the syslog identity.
default[:redis][:syslog_ident] = "redis"
#
# Specify the syslog facility. Must be USER or between LOCAL0-LOCAL7.
default[:redis][:syslog_facility] = "local0"
#
# Set the number of databases. The default database is DB 0, you can select
# a different one on a per-connection basis using SELECT <dbid> where
# dbid is a number between 0 and 'databases'-1
default[:redis][:databases] = 16



###################################################################### SNAPSHOTTING
#
# Save the DB on disk:
#
#   save <seconds> <changes>
#
#   Will save the DB if both the given number of seconds and the given
#   number of write operations against the DB occurred.
#
#   In the example below the behaviour will be to save:
#   after 900 sec (15 min) if at least 1 key changed
#   after 300 sec (5 min) if at least 10 keys changed
#   after 60 sec if at least 10000 keys changed
#
#   Note: you can disable saving at all by leaving it an empty hash
#
# default[:redis][:save_to_disk] = {
#   900 => 1,
#   300 => 10,
#   60  => 10000
# }
default[:redis][:save_to_disk] = {}
#
# Compress string objects using LZF when dump .rdb databases?
# For default that's set to 'yes' as it's almost always a win.
# If you want to save some CPU in the saving child set it to 'no' but
# the dataset will likely be bigger if you have compressible values or keys.
default[:redis][:rdbcompression] = "yes"
#
# The filename where to dump the DB
default[:redis][:dbfilename] = "redis_dump.rdb"

# The working directory.
#
# The DB will be written inside this directory, with the filename specified
# above using the 'dbfilename' configuration directive.
#
# Also the Append Only File will be created inside this directory.
#
# Note that you must specify a directory here, not a file name.
default[:redis][:datadir] = "/var/db/redis"



###################################################################### REPLICATION
#
# Master-Slave replication. Use slaveof to make a Redis instance a copy of
# another Redis server. Note that the configuration is local to the slave
# so for example it is possible to configure the slave to save the DB with a
# different interval, or to listen to another port, and so on.
default[:redis][:slaveof] = false
#
# If the master is password protected (using the "requirepass" configuration
# directive below) it is possible to tell the slave to authenticate before
# starting the replication synchronization process, otherwise the master will
# refuse the slave request.
default[:redis][:masterauth] = false
#
# When a slave lost the connection with the master, or when the replication
# is still in progress, the slave can act in two different ways:
#
# 1) if slave-serve-stale-data is set to 'yes' (the default) the slave will
#    still reply to client requests, possibly with out of data data, or the
#    data set may just be empty if this is the first synchronization.
#
# 2) if slave-serve-stale data is set to 'no' the slave will reply with
#    an error "SYNC with master in progress" to all the kind of commands
#    but to INFO and SLAVEOF.
default[:redis][:slave_serve_stale_data] = "yes"
#
# Slaves send PINGs to server in a predefined interval. It's possible to change
# this interval with the repl_ping_slave_period option. The default value is 10
# seconds.
default[:redis][:repl_ping_slave_period] = 10
#
# The following option sets a timeout for both Bulk transfer I/O timeout and
# master data or ping response timeout. The default value is 60 seconds.
#
# It is important to make sure that this value is greater than the value
# specified for repl-ping-slave-period otherwise a timeout will be detected
# every time there is low traffic between the master and the slave.
default[:redis][:repl_timeout] = 60



########################################################################## SECURITY
#
# Require clients to issue AUTH <PASSWORD> before processing any other
# commands.  This might be useful in environments in which you do not trust
# others with access to the host running redis-server.
#
# This should stay commented out for backward compatibility and because most
# people do not need auth (e.g. they run their own servers).
#
# Warning: since Redis is pretty fast an outside user can try up to
# 150k passwords per second against a good box. This means that you should
# use a very strong password otherwise it will be very easy to break.
default[:redis][:requirepass] = false
#
# Command renaming.
#
# It is possilbe to change the name of dangerous commands in a shared
# environment. For instance the CONFIG command may be renamed into something
# of hard to guess so that it will be still available for internal-use
# tools but not available for general clients.
#
# Example:
#
# rename-command CONFIG b840fc02d524045429941cc15f59e41cb7be6c52
#
# It is also possilbe to completely kill a command renaming it into
# an empty string:
#
# rename-command CONFIG ""
#
# You only need to provide the string component, e.g. "" or "b840fc02d524"
default[:redis][:rename_command] = false



############################################################################ LIMITS
#
# Don't need to change anything, the defaults are fine.
# Add config variables as required.



################################################################## APPEND ONLY MODE
#
# Don't need to change anything, the defaults are fine.
# Add config variables as required.



########################################################################## SLOW LOG
#
# Don't need to change anything, the defaults are fine.
# Add config variables as required.



################################################################### ADVANCED CONFIG
#
# Don't need to change anything, the defaults are fine.
# Add config variables as required.



#################################################################### VIRTUAL MEMORY
#
### WARNING! Virtual Memory is deprecated in Redis 2.4
