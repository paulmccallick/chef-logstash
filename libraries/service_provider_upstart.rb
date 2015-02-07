class Chef
  class Provider
    class LogstashServiceUpstart < LogstashServiceBase
      action :enable do
        tp = template "/etc/init/#{new_resource.service_name}.conf" do
          mode      '0644'
          source    "init/upstart/#{new_resource.install_type}.erb"
          variables(
            user_supported:      ::Logstash.upstart_supports_user?(node),
            home:                new_resource.home,
            name:                new_resource.name,
            command:             new_resource.command,
            args:                args,
            user:                new_resource.user,
            group:               new_resource.group,
            description:         new_resource.description,
            max_heap:            new_resource.max_heap,
            min_heap:            new_resource.min_heap,
            gc_opts:             new_resource.gc_opts,
            java_opts:           new_resource.java_opts,
            ipv4_only:           new_resource.ipv4_only,
            debug:               new_resource.debug,
            log_file:            new_resource.log_file,
            workers:             new_resource.workers,
            supervisor_gid:      new_resource.supervisor_gid,
            upstart_with_sudo:   new_resource.upstart_with_sudo,
            nofile_soft:         new_resource.nofile_soft,
            nofile_hard:         new_resource.nofile_hard
          )
          cookbook 'logstash'
          notifies :restart, "service[#{new_resource.service_name}]", :delayed
        end
        new_resource.updated_by_last_action(tp.updated_by_last_action?)
        sv = service new_resource.service_name do
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
    end
  end
end
