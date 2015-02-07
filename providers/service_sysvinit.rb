action :enable do
  tp = template "/etc/init.d/#{svc[:service_name]}" do
    source "init/sysvinit/#{svc[:install_type]}.erb"
    cookbook  svc[:templates_cookbook]
    owner 'root'
    group 'root'
    mode '0774'
    variables(
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
      config_file: "#{svc[:home]}/etc/conf.d"
    )
    notifies :restart, "service[#{svc[:service_name]}]", :delayed
  end
  new_resource.updated_by_last_action(tp.updated_by_last_action?)
  sv = service svc[:service_name] do
    supports restart: true, reload: true, status: true
    action [:enable, :start]
  end
  new_resource.updated_by_last_action(sv.updated_by_last_action?)
end
def service_for_actions
  service new_resource.service_name do
    provider Chef::Provider::Service::Init
  end
end
