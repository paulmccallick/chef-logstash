
action :enable do
  svc = svc_vars
  Chef::Log.info("Using init method #{svc[:method]} for #{svc[:service_name]}")
  @run_context.include_recipe 'runit::default'
  ri = runit_service svc[:service_name] do
    options(
      name:             new_resource.name,
      home:             home,
      max_heap:         new_resource.max_heap,
      min_heap:         new_resource.min_heap,
      gc_opts:          new_resource.gc_opts,
      java_opts:        new_resource.java_opts,
      ipv4_only:        new_resource.ipv4_only,
      debug:            new_resource.debug,
      log_file:         new_resource.log_file,
      workers:          new_resource.workers,
      install_type:     new_resource.install_type,
      supervisor_gid:   new_resource.supervisor_gid,
      user:             new_resource.user,
      web_address:      new_resource.web_address,
      web_port:         new_resource.web_port
    )
    run_template_name   'logstash'
    log_template_name   'logstash'
  end

  new_resource.updated_by_last_action(ri.updated_by_last_action?)
end

def service_for_actions
  @run_context.include_recipe 'runit::default'
  runit_service new_resource.service_name
end
