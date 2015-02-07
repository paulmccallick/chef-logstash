
class Chef
  class Provider
    class LogstashInstanceProviderTarball < Chef::Provider::LWRPBase

      def create
        @run_context.include_recipe 'ark::default'
        arkit = ark new_resource.name do
          url       new_resource.source_url
          checksum  new_resource.checksum
          owner     new_resource.user
          group     new_resource.group
          mode      0755
          version   new_resource.version
          path      new_resource.basedir
          action    :put
        end
        new_resource.updated_by_last_action(arkit.updated_by_last_action?)

        %w(bin etc lib log tmp etc/conf.d patterns).each do |ldir|
          r = directory "#{new_resource.instance_dir}/#{ldir}" do
            action :create
            mode '0755'
            owner new_resource.user
            group new_resource.group
          end
          new_resource.updated_by_last_action(r.updated_by_last_action?)
        end
      end
    end
  end
end
