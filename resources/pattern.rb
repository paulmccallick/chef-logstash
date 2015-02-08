# Encoding: utf-8
# Cookbook Name:: logstash
# Resource:: patterns
# Author:: John E. Vincent
# Copyright 2014, John E. Vincent
# License:: Apache 2.0

actions :create

default_action :create if defined?(default_action)

attribute :instance,    kind_of: String, name_attribute: true, default: 'server'
attribute :basedir, kind_of: String, default: '/opt/logstash'
attribute :patterns, kind_of: Array, default: []
attribute :owner, kind_of: String, default: 'logstash'
attribute :group, kind_of: String, default: 'logstash'
attribute :mode,  kind_of: String, default: '0644'

def path( arg=nil )
  if arg.nil? and @path.nil?
    ::File.join(@basedir, @instance, 'patterns',@instance)
  else
    set_or_return( path arg, :kind_of => String )
  end
end
