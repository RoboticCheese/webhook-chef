# Encoding: UTF-8
#
# Cookbook Name:: webhook
# Library:: provider_webhook_app
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
require_relative 'resource_webhook_app'

class Chef
  class Provider
    # A parent Chef provider for the Webhook app
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class WebhookApp < Provider
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
      # @return [Chef::Resource::WebhookApp]
      #
      def load_current_resource
        @current_resource ||= Resource::WebhookApp.new(new_resource.name)
      end

      #
      # Download and install the Webhook CLI
      #
      def action_install
        package.run_action(:install)
        new_resource.installed = true
      end

      private

      #
      # A Chef resource for the Webhook app package
      #
      def package
        @package ||= send("package_#{node['platform_family']}")
      end

      #
      # Build and return a DmgPackage resource for OS X systems
      #
      # @return [Chef::Resource::DmgPackage]
      #
      def package_mac_os_x
        p = Resource::DmgPackage.new(package_url, run_context)
        p.app(filename.gsub(/\.dmg$/, ''))
        p.volumes_dir(filename.gsub(/\.dmg$/, ''))
        p.source(package_url)
        p.type('app')
        p
      end

      #
      # Build and return a Windows package resource
      #
      # @return [Chef::Resource::WindowsPackage]
      #
      def package_windows
        p = Resource::WindowsPackage.new(wh_app_name, run_context)
        p.source(package_url)
        p
      end

      #
      # The remote URL of the package file
      #
      # @return [String]
      #
      def package_url
        if new_resource.package_url.nil?
          ::File.join(wh_app_package_repo, filename)
        else
          new_resource.package_url
        end
      end

      #
      # The platform-dependent name of the package file
      #
      # @return [String]
      #
      def filename
        case node['platform_family']
        when 'mac_os_x'
          "#{wh_app_name}.dmg"
        when 'windows'
          'setup.exe'
        else
          fail(Exceptions::UnsupportedPlatform, node['platform_family'])
        end
      end
    end
  end
end
