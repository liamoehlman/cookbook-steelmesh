maintainer       "Sidelab Pty Ltd"
maintainer_email "liam.oehlman@sidelab.com"
license          "All rights reserved"
description      "Installs/Configures node"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.7"

recipe            "node", "Installs nodejs from source"

depends "build-essential"

%w{ ubuntu debian centos redhat fedora }.each do |os|
  supports os
end

attribute "node/version",
  :display_name => "Node Version",
  :description => "Which version of nodejs to install",
  :default => "0.6.13"

