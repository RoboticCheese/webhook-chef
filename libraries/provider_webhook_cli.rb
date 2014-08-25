# Encoding: UTF-8
#
# Cookbook Name:: webhook
# Library:: provider_webhook_cli
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

require 'chef/provider'
require_relative 'webhook_helpers'
require_relative 'resource_webhook_cli'

class Chef
  class Provider
    # A Chef provider for the Webhook CLI
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class WebhookCli < Provider
      include ::Webhook::Helpers

      #
      # Advertise WhyRun support for this provider
      #
      # @return [TrueClass, FalseClass]
      #
      def whyrun_supported?
        true
      end

      #
      # Load and return the current resource
      #
      # @return [Chef::Resource::WebhookCli]
      #
      def load_current_resource
        @current_resource ||= Resource::WebhookCli.new(new_resource.name)
      end

      #
      # Download and install the Webhook CLI
      #
      def action_install
        grunt_package.run_action(:install)
        wh_package.run_action(:install)
        new_resource.installed = true
      end

      #
      # Uninstall the Webhook CLI
      def action_uninstall
        wh_package.run_action(:uninstall)
        grunt_package.run_action(:uninstall)
        new_resource.installed = false
      end

      private

      #
      # A Chef resource for the wh NPM package
      #
      # @return [Chef::Resource::NodejsNpm]
      #
      def wh_package
        @wh_package ||= Resource::NodejsNpm.new('wh', run_context)
        unless new_resource.version == 'latest'
          @wh_package.version(new_resource.version)
        end
        @wh_package
      end

      #
      # A Chef resource for the Grunt NPM package
      #
      # @return [Chef::Resource::NodejsNpm]
      #
      def grunt_package
        @grunt_package ||= Resource::NodejsNpm.new('grunt', run_context)
        unless new_resource.grunt_version.nil?
          @grunt_package.version(new_resource.grunt_version)
        end
        @grunt_package
      end
    end
  end
end
