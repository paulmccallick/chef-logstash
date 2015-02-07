class Chef
  class Provider
    class LogstashServiceSystemd < LogstashServiceProviderBase
      action :enable do

        ex = execute 'reload-systemd' do
          command 'systemctl --system daemon-reload'
          action :nothing
        end
        new_resource.updated_by_last_action(ex.updated_by_last_action?)
        tp = template "/etc/systemd/system/#{new_resource.service_name}.service" do
          tp = source "init/systemd/#{new_resource.install_type}.erb"
          owner 'root'
          group 'root'
          mode '0755'
          variables(
            home: new_resource.home,
            user: new_resource.user,
            supervisor_gid: new_resource.supervisor_gid,
            args: default_args
          )
          cookbook 'logstash'
          notifies :run, 'execute[reload-systemd]', :immediately
          notifies :restart, "service[#{new_resource.service_name}]", :delayed
        end
        new_resource.updated_by_last_action(tp.updated_by_last_action?)
        sv = service new_resource.service_name do
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

      def default_args
        args      = ['agent', '-f', "#{home}/etc/conf.d/"]
        args.concat ['-vv'] if new_resource.debug
        args.concat ['-l', "#{new_resource.home}/log/#{new_resource.log_file}"] if new_resource.log_file
        args.concat ['-w', new_resource.workers.to_s] if new_resource.workers
        args
      end
    end
  end
end
