# Encoding: UTF-8
#
# Cookbook Name:: webhook
# Library:: webhook_helpers
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

module Webhook
  # A set of helper methods shared by all the resources and providers
  #
  # @author Jonathan Hartman <j@p4nt5.com>
  module Helpers
    #
    # The name of the webhook app (used in the Windows registry, etc.)
    #
    # @return [String]
    #
    def wh_app_name
      'Webhook'
    end

    #
    # The base URL of Webhook app packages
    #
    # @return [String]
    #
    def wh_app_package_repo
      'http://dump.webhook.com/application'
    end

    #
    # Is this symbol/string a valid version identifier?
    #
    # @param [String, Symbol]
    # @return [TrueClass, FalseClass]
    #
    def valid_version?(arg)
      return false unless arg.is_a?(String) || arg.is_a?(Symbol)
      return true if arg.to_s == 'latest'
      arg.match(/^[0-9]+\.[0-9]+\.[0-9]+$/) ? true : false
    end
  end
end
