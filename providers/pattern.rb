# Encoding: utf-8
# Cookbook Name:: logstash
# Provider:: patterns
# Author:: John E. Vincent
# License:: Apache 2.0
#
# Copyright 2014, John E. Vincent
require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

use_inline_resources

action :create do
  tp = template @path do
    source      'patterns/custom_patterns.erb'
    cookbook    'logstash'
    owner       new_resource.owner
    group       new_resource.group
    mode        new_resource.mode
    variables   new_resource.variables
    notifies    :restart, "logstash_service[#{new_resource.instance}]"
    action      :create
  end
end
