# Encoding: utf-8
# Cookbook Name:: logstash
# Provider:: service
# Author:: John E. Vincent
# License:: Apache 2.0
#
# Copyright 2014, John E. Vincent

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

# Creates a provider for the splunk_app resource.
class Chef
  class Provider
    class LogstashServiceProviderBase < Chef::Provider::LWRPBase

      action :restart do
        new_resource.updated_by_last_action(service_action(:restart))
      end

      action :start do
        new_resource.updated_by_last_action(service_action(:start))
      end

      action :stop do
        new_resource.updated_by_last_action(service_action(:stop))
      end

      action :reload do
        new_resource.updated_by_last_action(service_action(:reload))
      end

      def home
        ::File.join(@basedir, @instance)
      end
      alias_method :chdir, :home

      private

      def service_for_actions
        fail 'This method should be overridden and create a service resource for restarts shutdowns etc'
      end

      def service_action(action)
        sv = service_for_actions
        sv.run_action(action)
        sv.updated_by_last_action?
      end
    end
  end
end
