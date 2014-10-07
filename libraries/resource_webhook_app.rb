# Encoding: UTF-8
#
# Cookbook Name:: webhook
# Library:: webhook_app
#
# Copyright 2014, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/resource'
require_relative 'webhook_helpers'
require_relative 'provider_webhook_app'

class Chef
  class Resource
    # A Chef resource for the Webhook app
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class WebhookApp < Resource
      include ::Webhook::Helpers

      attr_accessor :installed
      alias_method :installed?, :installed

      def initialize(name, run_context = nil)
        super
        @resource_name = :webhook_app
        @provider = Provider::WebhookApp
        @action = :install
        @allowed_actions = [:install]

        @installed = false
      end

      #
      # The URL to install the package from
      #
      # @param [String, NilClass]
      # @return [String, NilClass]
      #
      def package_url(arg = nil)
        set_or_return(:package_url,
                      arg,
                      kind_of: [String, NilClass],
                      default: nil,
                      callbacks: {
                        'Package must be a `.dmg` or `.exe` file' =>
                          ->(a) { a.end_with?('.dmg') || a.end_with?('.exe') }
                      })
      end
    end
  end
end
