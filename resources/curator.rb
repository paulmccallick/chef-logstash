# Encoding: utf-8
# Cookbook Name:: logstash
# Resource:: config
# Author:: John E. Vincent
# Copyright 2014, John E. Vincent
# License:: Apache 2.0

actions :create, :delete

default_action :create if defined?(default_action)

attribute :instance,      kind_of: String, name_attribute: true, default: 'server'
attribute :days_to_keep,  kind_of: Integer, default: 31
attribute :minute,        kind_of: String, default: '0'
attribute :hour,          kind_of: String, default: '*'
attribute :log_file,      kind_of: String, default: '/dev/null'
attribute :user,          kind_of: String, default: 'logstash' 
attribute :bin_dir,       kind_of: String, default: '/usr/local/bin'
