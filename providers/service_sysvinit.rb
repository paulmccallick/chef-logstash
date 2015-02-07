action :enable do
  tp = template "/etc/init.d/#{new_resource.service_name}" do
    source "init/sysvinit/#{new_resource.install_type}.erb"
    cookbook  new_resource.templates_cookbook
    owner 'root'
    group 'root'
    mode '0774'
    variables(
      home:             new_resource.home,
      name:             new_resource.name,
      command:          new_resource.command,
      args:             args,
      user:             new_resource.user,
      group:            new_resource.group,
      description:      new_resource.description,
      max_heap:         new_resource.max_heap,
      min_heap:         new_resource.min_heap,
      gc_opts:          new_resource.gc_opts,
      java_opts:        new_resource.java_opts,
      ipv4_only:        new_resource.ipv4_only,
      debug:            new_resource.debug,
      log_file:         new_resource.log_file,
      workers:          new_resource.workers,
      supervisor_gid:   new_resource.supervisor_gid,
      config_file:      "#{new_resource.home}/etc/conf.d"
    )
    notifies :restart, "service[#{new_resource.service_name}]", :delayed
  end
  new_resource.updated_by_last_action(tp.updated_by_last_action?)
  sv = service new_resource.service_name do
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
