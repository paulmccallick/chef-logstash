
class Chef
  class Provider
    class LogstashInstanceProviderTarball < LogstashInstanceProviderBase

      def create
        bdr = directory @base_directory do
          action :create
          mode '0755'
          owner new_resource.user
          group new_resource.group
        end
        new_resource.updated_by_last_action(bdr.updated_by_last_action?)

        idr = directory new_resource.instance_dir do
          action :create
          mode '0755'
          owner new_resource.user
          group new_resource.group
        end
        new_resource.updated_by_last_action(idr.updated_by_last_action?)

        %w(bin etc lib log tmp etc/conf.d patterns).each do |ldir|
          r = directory "#{new_resource.instance_dir}/#{ldir}" do
            action :create
            mode '0755'
            owner new_resource.user
            group new_resource.group
          end
          new_resource.updated_by_last_action(r.updated_by_last_action?)
        end

        rfr = remote_file "#{new_resource.instance_dir}/lib/logstash-#{new_resource.version}.jar" do
          owner new_resource.user
          group new_resource.group
          mode '0755'
          source new_resource.source_url
          checksum new_resource.checksum
        end
        new_resource.updated_by_last_action(rfr.updated_by_last_action?)

        lr = link "#{new_resource.instance_dir}/lib/logstash.jar" do
          to "#{new_resource.instance_dir}/lib/logstash-#{new_resource.version}.jar"
          only_if { new_resource.auto_symlink }
        end
        new_resource.updated_by_last_action(lr.updated_by_last_action?)

      end
    end
  end
end
