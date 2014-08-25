# Encoding: UTF-8
#
# Cookbook Name:: webhook
# Library:: webhook_cli
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
require_relative 'provider_webhook_cli'

class Chef
  class Resource
    # A Chef resource for the Webhook CLI
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class WebhookCli < Resource
      include ::Webhook::Helpers

      attr_accessor :installed
      alias_method :installed?, :installed

      def initialize(name, run_context = nil)
        super
        @resource_name = :webhook_cli
        @provider = Chef::Provider::WebhookCli
        @action = :install
        @allowed_actions = [:install, :uninstall]

        @installed = false
      end

      #
      # The version of the CLI to install
      #
      # @param [String, NilClass]
      # @return [String]
      def version(arg = nil)
        set_or_return(:version,
                      arg,
                      kind_of: String,
                      default: 'latest',
                      callbacks: {
                        "Valid versions are 'latest' or 'x.y.z'" =>
                          ->(a) { valid_version?(a) }
                      })
      end

      #
      # The version of the Grunt dependency to install
      #
      # @param [String, NilClass]
      # @return [String]
      def grunt_version(arg = nil)
        set_or_return(:grunt_version,
                      arg,
                      kind_of: String,
                      default: 'latest',
                      callbacks: {
                        "Valid versions are 'latest' or 'x.y.z'" =>
                          ->(a) { valid_version?(a) }
                      })
      end
    end
  end
end
