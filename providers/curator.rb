# Encoding: utf-8
# Cookbook Name:: logstash
# Provider:: curator
# Author:: John E. Vincent
# License:: Apache 2.0
#
# Copyright 2014, John E. Vincent

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut


action :create do
  cur_instance      =  new_resource.instance
  cur_days_to_keep  =  new_resource.days_to_keep
  cur_log_file      =  new_resource.log_file
  cur_hour          =  new_resource.hour
  cur_minute        =  new_resource.minute
  cur_user          =  new_resource.user
  cur_bin_dir       =  new_resource.bin_dir

  @run_context.include_recipe 'python::pip'

  pi = python_pip 'elasticsearch-curator' do
    action :install
  end
  new_resource.updated_by_last_action(pi.updated_by_last_action?)

  server_ip = ::Logstash.service_ip(node, cur_instance, 'elasticsearch')
  cr = cron "curator-#{cur_instance}" do
    command "#{cur_bin_dir}/curator --host #{server_ip} delete --older-than #{cur_days_to_keep} &> #{cur_log_file}"
    user    cur_user
    minute  cur_minute
    hour    cur_hour
    action  [:create]
  end
  new_resource.updated_by_last_action(cr.updated_by_last_action?)
end

action :delete do
  cur_instance      =  new_resource.instance
  cur_days_to_keep  =  new_resource.days_to_keep
  cur_log_file      =  new_resource.log_file
  cur_hour          =  new_resource.hour
  cur_minute        =  new_resource.minute
  cur_user          =  new_resource.user
  cur_bin_dir       =  new_resource.bin_dir

  @run_context.include_recipe 'python::pip'

  pi = python_pip 'elasticsearch-curator' do
    action :uninstall
  end
  new_resource.updated_by_last_action(pi.updated_by_last_action?)

  cr = cron "curator-#{cur_instance}" do
    command "#{cur_bin_dir}/curator --host #{::Logstash.service_ip(node, cur_instance, 'elasticsearch')} delete --older-than #{cur_days_to_keep} 2>&1 > #{cur_log_file}"
    user    cur_user
    minute  cur_minute
    hour    cur_hour
    action  [:delete]
  end
  new_resource.updated_by_last_action(cr.updated_by_last_action?)
end
