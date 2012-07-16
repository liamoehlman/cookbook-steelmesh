DESCRIPTION
===========

Installs and configures CouchDB from source.

REQUIREMENTS
============

## Platform

Tested on Ubuntu 12.04.

## Cookbooks

* erlang
* build-essential

ATTRIBUTES
==========

* `node['couch']['version']`     = version to download, either "1.x.x" or "latest" for a git install
* `node['couch']['mirror']`      = location to download from

* `node['couch']['git']`         = git repository to use

* `node['couch']['dir']`         = Location to install to
* `node['couch']['user']`        = Couchdb user
* `node['couch']['group']`       = Couchdb group

* `node['couch']['init']`        = Location of the init.d script when installed from source to copy to the system dir
* `node['couch']['logrotate']`   = Location of the logrotate.d file when installed from source to copy to the system dir

* `node['couch']['admin']`       = Admin user
* `node['couch']['password']`    = Admin password

* `node['couch']['listen']`      = Listen ip, defaults to 0.0.0.0 If using in production recommended is 127.0.0.1

RECIPES
=======

source
-------

Installs couchdb from source, either from .tar.gz or from git. Copys over the relevant files from the install to create a system service.

CREDITS
=======

Originally this cookbook started out as a modification from the original opscode couchdb cookbook. However very little, if any of it remains. It did provide a good template for the construction of this ubuntu specific one and that deserves recgonition.

LICENSE AND AUTHOR
==================

Author:: Liam Oehlman (<liam.oehlman@sidelab.com>)

Copyright 2012, Sidelab Pty Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

