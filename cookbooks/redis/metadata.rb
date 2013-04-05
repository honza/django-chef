maintainer        "Gerhard Lazu"
maintainer_email  "gerhard@lazu.co.uk"
license           "Apache 2.0"
description       "Installs and configures latest stable Redis"
version           "2.1.0"

recipe "redis::source", "Installs redis from source"
recipe "redis::master", "Installs redis from source and configures it as a master instance"
recipe "redis::slave", "Installs redis from source and configures it as a slave instance"

supports "ubuntu"
supports "debian"

depends "build-essential"
