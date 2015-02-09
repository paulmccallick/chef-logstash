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
  es_output = {}
  if new_resource.es_output != :none
    es_output['elasticsearch'] = {}
    case new_resource.es_output
    when :embedded
      es_output['elasticsearch']['embedded'] = 'true' 
    when :query
      es_servers = search(:node, new_resource.es_query)
      fail "no elasticsearch server found using query #{new_resource.es_query}" if es_servers.empty?
      es_output['elasticsearch']['host'] = es_servers[0]['ipaddress']
    when :server
      es_output['elasticsearch']['host'] = new_resource.es_server
    else
      fail "unknown value used for es_output"
    end
  end
  variables = {
    inputs: Logstash.section_to_str(new_resource.inputs),
    filters: Logstash.section_to_str(new_resource.filters),
    outputs: Logstash.section_to_str(new_resource.outputs),
    es_output: Logstash.section_to_str(es_output)
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
