# Encoding: UTF-8

require 'spec_helper'

module ChefSpec
  module API
    # Some simple matchers for the webhook_app resource
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    module WebhookAppMatchers
      ChefSpec::Runner.define_runner_method :webhook_app

      def install_webhook_app(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:webhook_app,
                                                :install,
                                                resource_name)
      end
    end
  end
end
