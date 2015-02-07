
action :enable do
  svc = svc_vars
  Chef::Log.info("Using init method #{svc[:method]} for #{svc[:service_name]}")
  @run_context.include_recipe 'runit::default'
  ri = runit_service svc[:service_name] do
    options(
      name: svc[:name],
      home: svc[:home],
      max_heap: svc[:max_heap],
      min_heap: svc[:min_heap],
      gc_opts: svc[:gc_opts],
      java_opts: svc[:java_opts],
      ipv4_only: svc[:ipv4_only],
      debug: svc[:debug],
      log_file: svc[:log_file],
      workers: svc[:workers],
      install_type: svc[:install_type],
      supervisor_gid: svc[:supervisor_gid],
      user: svc[:user],
      web_address: svc[:web_address],
      web_port: svc[:web_port]
    )
    cookbook  svc[:templates_cookbook]
    run_template_name svc[:runit_run_template_name]
    log_template_name svc[:runit_log_template_name]
  end
  new_resource.updated_by_last_action(ri.updated_by_last_action?)
end

def service_for_actions
  @run_context.include_recipe 'runit::default'
  runit_service svc[:service_name]
end
