
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

        sd = directory "#{new_resource.instance_dir}/source" do
          action :create
          owner new_resource.user
          group new_resource.group
          mode '0755'
        end
        new_resource.updated_by_last_action(sd.updated_by_last_action?)

        gr = git "#{new_resource.instance_dir}/source" do
          repository @repo
          reference @sha
          action :sync
          user new_resource.user
          group new_resource.group
        end
        new_resource.updated_by_last_action(gr.updated_by_last_action?)

        source_version = @sha || "v#{@version}"
        er = execute 'build-logstash' do
          cwd "#{new_resource.instance_dir}/source"
          environment(JAVA_HOME: @java_home)
          user ls_user # Changed from root cause building as root...WHA?
          command "make clean && make VERSION=#{source_version} jar"
          action :run
          creates "#{new_resource.instance_dir}/source/build/logstash-#{source_version}--monolithic.jar"
          not_if "test -f #{new_resource.instance_dir}/source/build/logstash-#{source_version}--monolithic.jar"
        end
        new_resource.updated_by_last_action(er.updated_by_last_action?)
        lr = link "#{new_resource.instance_dir}/lib/logstash.jar" do
          to "#{new_resource.instance_dir}/source/build/logstash-#{source_version}--monolithic.jar"
          only_if { new_resource.auto_symlink }
        end
        new_resource.updated_by_last_action(lr.updated_by_last_action?)
      end
    end
  end
end
