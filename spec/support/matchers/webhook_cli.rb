# Encoding: UTF-8
#
# Cookbook Name:: webhook
# Spec:: support/matchers/cli
#
# Copyright (C) 2014, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'

module ChefSpec
  module API
    # Some simple matchers for the webhook_cli resource
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    module WebhookCLIMatchers
      ChefSpec::Runner.define_runner_method :webhook_cli

      def install_webhook_cli(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:webhook_cli,
                                                :install,
                                                resource_name)
      end
    end
  end
end
