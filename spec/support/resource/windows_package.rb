# Encoding: UTF-8

require 'spec_helper'

class Chef
  class Resource
    # A fake windows_package resource
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class WindowsPackage < Resource::Package
      def initialize(name, run_context = nil)
        super
        @resource_name = :windows_package
        @action = :install
        @allowed_actions = [:install, :remove]
      end

      def source(arg = nil)
        set_or_return(:source, arg, kind_of: String)
      end
    end
  end
end
