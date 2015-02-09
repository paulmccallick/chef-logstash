# Encoding: utf-8
# Cookbook Name:: logstash
# Resource:: config
# Author:: John E. Vincent
# Copyright 2014, John E. Vincent
# License:: Apache 2.0

actions :create

default_action :create if defined?(default_action)

attribute :instance , kind_of: String , name_attribute: true, default: 'server'
attribute :basedir ,  kind_of: Sring  , default: '/opt/logstash'
attribute :inputs   , kind_of: Hash   , default: {}
attribute :filters  , kind_of: Hash   , default: {}
attribute :outputs  , kind_of: Hash   , default: {}
attribute :owner    , kind_of: String, default: 'logstash'
attribute :group    , kind_of: String, default: 'logstash'
attribute :mode     , kind_of: String, default: '0644'
# es_output value can be :none, :query, :embedded, or :server
attribute :es_output     , kind_of: [ Symbol], default: :none
attribute :es_server     , kind_of: [String]
attribute :es_query     , kind_of: [String]


def path( arg=nil )
  if arg.nil? and @path.nil?
    ::File.join(@basedir, @instance, 'config', "#{@instance}.conf")
  else
    set_or_return( path arg, :kind_of => String )
  end
end
