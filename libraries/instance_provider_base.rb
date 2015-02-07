# Encoding: utf-8
# Cookbook Name:: logstash
# Provider:: instance
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
    class LogstashInstanceProviderBase < Chef::Provider::LWRPBase
      def instance_dir 
        "#{@base_directory}/#{new_resource.name}".clone
      end

      action :delete do
        ls = ls_vars

        idr = directory new_resource.instance_dir do
          recursive   true
          action      :delete
        end
        new_resource.updated_by_last_action(idr.updated_by_last_action?)
      end

      action :create do
        ls = ls_vars

        if  new_resource.create_account
          ur = user new_resource.user do
            home new_resource.homedir
            system true
            action :create
            manage_home true
            uid new_resource.uid
          end
          new_resource.updated_by_last_action(ur.updated_by_last_action?)

          gr = group new_resource.group do
            gid new_resource.gid
            members new_resource.user
            append true
            system true
          end
          new_resource.updated_by_last_action(gr.updated_by_last_action?)
        end

        create
        logrotate(ls) if new_resource.logrotate_enable
      end

      def create
        raise 'This method should be overridden by a provider specific implementation'
      end

      private

      def logrotate(ls)
        name = new_resource.name

        @run_context.include_recipe 'logrotate::default'

        logrotate_app "logstash_#{name}" do
          path "#{new_resource.instance_dir}/log/*.log"
          size new_resource.logrotate_size if new_resource.logrotate_use_filesize
          frequency new_resource.logrotate_frequency
          rotate new_resource.logrotate_max_backup
          options new_resource.logrotate_options
          create "664 #{new_resource.user} #{new_resource.group}"
        end
      end
    end
  end
end
