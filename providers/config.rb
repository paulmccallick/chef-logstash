# Encoding: utf-8
# Cookbook Name:: logstash
# Provider:: config
# Author:: John E. Vincent
# License:: Apache 2.0
#
# Copyright 2014, John E. Vincent

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

use_inline_resources

action :create do
    variables = {
      inputs: Logstash.section_to_str(new_resource.inputs),
      filters: Logstash.section_to_str(new_resource.filters),
      outputs: Logstash.section_to_str(new_resource.outputs)
    }
    template new_resource.path do
      source      'config/conf.erb'
      cookbook    'logstash'
      owner       new_resource.owner
      group       new_resource.group
      mode        new_resource.mode
      variables   variables
      action      :create
    end
  end
