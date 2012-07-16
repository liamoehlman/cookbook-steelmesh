maintainer       "Sidelab Pty Ltd"
maintainer_email "liam.oehlman@sidelab.com"
license          "Apache 2.0"
description      "Installs/Configures steelmesh"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

depends "git"

supports          "ubuntu", ">= 12.04" # for package in APT

recipe            "steelmesh", "Installs steelmesh"
