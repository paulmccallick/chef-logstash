# Encoding: utf-8
# Cookbook Name:: logstash
# Resource:: instance
# Author:: John E. Vincent
# Copyright 2014, John E. Vincent
# License:: Apache 2.0

actions :enable, :start, :restart, :reload, :stop

default_action :enable if defined?(default_action)

attribute :instance, kind_of: String, name_attribute: true, required: true
attribute :command, kind_of: String
attribute :args, kind_of: Array
attribute :java_opts, kind_of: String, default: ''
attribute :basedir, kind_of: String, default: '/opt/logstash'
attribute :user, kind_of: String, default: 'logstash'
attribute :group, kind_of: String, default: 'logstash'
attribute :log_file, kind_of: String, default: 'logstash.log'
attribute :gc_opts, kind_of: String, default: '-XX:+UseParallelOldGC'
attribute :ipv4_only, kind_of:[TrueClass, FalseClass], default: false
attribute :workers, kind_of: FixNum, default: 1
attribute :debug, kind_of:[TrueClass, FalseClass], default: false
attribute :install_type, kind_of: String, default: 'tarball'
attribute :supervisor_gid, kind_of: String, default: 'logstash'
attribute :limit_nofile_hard, kind_of: String, default: 65550
attribute :limit_nofile_soft, kind_of: String, default: 65550


# dynamic attribute defaults are beyond the lwrp syntax
def service_name( arg=nil )
  if arg.nil? and @service_name.nil?
    "logstash_#{instance}"
  else
    set_or_return( service_name arg, :kind_of => String )
  end
end

# dynamic attribute defaults are beyond the lwrp syntax
def description( arg=nil )
  if arg.nil? and @description.nil?
    @service_name
  else
    set_or_return( description arg, :kind_of => String )
  end
end
