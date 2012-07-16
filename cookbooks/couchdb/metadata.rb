maintainer        "Sidelab"
maintainer_email  "liam.oehlman@sidelab.com"
license           "Apache 2.0"
description       "Installs CouchDB package from sourc  and starts service"
long_description  <<-EOH
Installs couchdb from source, either from stable or the git repository. Then starts the service using the scripts provided by the couchdb install.
EOH
version           "1.0.0"
depends           "erlang"
depends           "build-essential"

recipe            "couchdb::source", "Installs and configures CouchDB from source"

supports          "ubuntu", ">= 12.04" # for package in APT

