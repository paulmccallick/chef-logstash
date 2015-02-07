action :enable do
  tp = template "/etc/init/#{svc[:service_name]}.conf" do
    mode      '0644'
    source    "init/upstart/#{svc[:install_type]}.erb"
    cookbook  svc[:templates_cookbook]
    variables(
      user_supported: ::Logstash.upstart_supports_user?(node),
      home: svc[:home],
      name: svc[:name],
      command: svc[:command],
      args: args,
      user: svc[:user],
      group: svc[:group],
      description: svc[:description],
      max_heap: svc[:max_heap],
      min_heap: svc[:min_heap],
      gc_opts: svc[:gc_opts],
      java_opts: svc[:java_opts],
      ipv4_only: svc[:ipv4_only],
      debug: svc[:debug],
      log_file: svc[:log_file],
      workers: svc[:workers],
      supervisor_gid: svc[:supervisor_gid],
      upstart_with_sudo: svc[:upstart_with_sudo],
      nofile_soft: svc[:nofile_soft],
      nofile_hard: svc[:nofile_hard]
    )
    notifies :restart, "service[#{svc[:service_name]}]", :delayed
  end
  new_resource.updated_by_last_action(tp.updated_by_last_action?)
  sv = service svc[:service_name] do
    provider Chef::Provider::Service::Upstart
    supports restart: true, reload: true, start: true, stop: true
    action [:enable]
  end
  new_resource.updated_by_last_action(sv.updated_by_last_action?)
end
def service_for_actions
  service new_resource.service_name do
    provider Chef::Provider::Service::Upstart
  end
end
