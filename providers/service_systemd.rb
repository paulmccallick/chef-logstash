action :enable do

  ex = execute 'reload-systemd' do
    command 'systemctl --system daemon-reload'
    action :nothing
  end
  new_resource.updated_by_last_action(ex.updated_by_last_action?)
  tp = template "/etc/systemd/system/#{svc[:service_name]}.service" do
    tp = source "init/systemd/#{svc[:install_type]}.erb"
    cookbook  svc[:templates_cookbook]
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      home: svc[:home],
      user: svc[:user],
      supervisor_gid: svc[:supervisor_gid],
      args: default_args
    )
    notifies :run, 'execute[reload-systemd]', :immediately
    notifies :restart, "service[#{svc[:service_name]}]", :delayed
  end
  new_resource.updated_by_last_action(tp.updated_by_last_action?)
  sv = service svc[:service_name] do
    provider Chef::Provider::Service::Systemd
    action [:enable, :start]
  end
  new_resource.updated_by_last_action(sv.updated_by_last_action?)
end

def service_for_actions
  service new_resource.service_name do
    provider Chef::Provider::Service::Systemd
  end
end
