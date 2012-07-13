maintainer        "Sidelab"
maintainer_email  "liam.oehlman@sidelab.com"
license           "Apache 2.0"
description       "Installs CouchDB package and starts service"
long_description  <<-EOH
Installs the CouchDB package if it is available from an package repository on
the node. If the package repository is not available, CouchDB needs to be 
installed via some other method, either a backported package, or compiled 
directly from source. CouchDB is available on Red Hat-based systems through
the EPEL Yum Repository.
EOH
version           "0.14.1"
depends           "erlang"
recipe            "couchdb::source", "Installs and configures CouchDB from source"
recipe            "couchdb::init", "Puts the init and logrotate files in when installed from source"

supports          "ubuntu", ">= 12.04" # for package in APT

