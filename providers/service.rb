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

def load_current_resource
  @instance = new_resource.instance
  @home = "#{@basedir}/#{@instance}"
  @method = new_resource.method || Logstash.get_attribute_or_default(node, @instance, 'init_method')
  @max_heap = Logstash.get_attribute_or_default(node, @instance, 'xmx')
  @min_heap = Logstash.get_attribute_or_default(node, @instance, 'xms')
  @java_opts = Logstash.get_attribute_or_default(node, @instance, 'java_opts')
  @chdir = @home
end

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


private

def default_args
  svc = svc_vars
  args      = ['agent', '-f', "#{svc[:home]}/etc/conf.d/"]
  args.concat ['-vv'] if svc[:debug]
  args.concat ['-l', "#{svc[:home]}/log/#{svc[:log_file]}"] if svc[:log_file]
  args.concat ['-w', svc[:workers].to_s] if svc[:workers]
  args
end

def service_for_actions
  fail 'This method should be overridden and create a service resource for restarts etc'
end

def service_action(action)
  sv = service_for_actions
  sv.run_action(action)
  sv.updated_by_last_action?
end

def svc_vars
  {
    name:                      @new_resource.instance,
    service_name:              @new_resource.service_name,
    home:                      @new_resource.home,
    method:                    @new_resource.method,
    command:                   @new_resource.command,
    description:               @new_resource.description,
    chdir:                     @new_resource.chdir,
    user:                      @new_resource.user,
    group:                     @new_resource.group,
    log_file:                  @new_resource.log_file,
    max_heap:                  @new_resource.max_heap,
    min_heap:                  @new_resource.min_heap,
    java_opts:                 @new_resource.java_opts,
    ipv4_only:                 @new_resource.ipv4_only,
    workers:                   @new_resource.workers,
    debug:                     @new_resource.debug,
    install_type:              @new_resource.install_type,
    supervisor_gid:            @new_resource.supervisor_gid,
    runit_run_template_name:   @new_resource.runit_run_template_name,
    runit_log_template_name:   @new_resource.runit_log_template_name,
    nofile_soft:               @new_resource.nofile_soft,
    nofile_hard:               @new_resource.nofile_hard
  }
end
