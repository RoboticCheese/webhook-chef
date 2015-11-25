# Encoding: UTF-8

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
