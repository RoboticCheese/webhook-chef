Webhook Cookbook
================
[![Cookbook Version](http://img.shields.io/cookbook/v/webhook.svg)][cookbook]
[![Build Status](http://img.shields.io/travis/RoboticCheese/webhook-chef.svg)][travis]

[cookbook]: https://supermarket.getchef.com/cookbooks/webhook
[travis]: http://travis-ci.org/RoboticCheese/webhook-chef

A cookbook for installing and configuring the various components of
[Webhook](http://www.webhook.com).

Requirements
------------

While the included recipes will handle installation of Node.js on their own,
the resources provided will not. Either use the recipes or ensure Node.js is
installed prior to calling a resource directly.

Usage
-----

This cookbook can be implemented either by calling its resource directly, or
adding the recipes that wrap it to your run_list.

Recipes
-------

***default***

***cli***

Installs Node.js and calls the webhook_cli resource to install the Webhook CLI.

Attributes
----------

***default***

| Attribute                                 | Default | Description                                                         |
|-------------------------------------------|---------|---------------------------------------------------------------------|
| `node['webhook']['cli']['version']`       | nil     | Install a specific version of the Webhook CLI instead of the latest |
| `node['webhook']['cli']['grunt_version']` | nil     | Install a specific version of Grunt instead of the latest           |

Resources
---------

***webhook_cli***

Wraps the installation of Grunt and the Webhook CLI NPM packages into a single
resource.

Syntax:

    webhook_cli 'webhook' do
      version '1.2.3'
      grunt_version '4.5.6'
      action :install
    end

Actions:

| Action       | Description                       |
|--------------|-----------------------------------|
| `:install`   | Install the Webhook CLI (default) |
| `:uninstall` | Uninstall the CLI                 |

Attributes:

| Attribute       | Default    | Description                          |
|-----------------|------------|--------------------------------------|
| `version`       | `'latest'` | Version of the wh package to install |
| `grunt_version` | `'latest'` | Version of the Grunt dep to install  |

Providers
---------

***webhook_cli***

Handles installs/uninstalls of the Webhook CLI, via NPM packages.

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run style checks and RSpec tests (`bundle exec rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

License & Authors
-----------------

- Author: Jonathan Hartman <j@p4nt5.com>

Copyright 2014, Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
