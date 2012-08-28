
# template "/usr/local/kafka/config/server.properties" do
#   variables(
#     :zookeeper_pairs => zookeeper_pairs
#   )
#   source "server.properties.erb"
# end

# template "/usr/local/kafka/bin/kafka-run-class.sh" do
#   source "kafka-run-class.sh.erb"
#   mode 0755
# end

version = node[:kafka][:version]

execute "backup kafka server.properties" do
  command "cp /opt/src/kafka-#{version}/config/server.properties /opt/src/kafka-#{version}/config/server.properties.orig"
  action :run
  creates "/opt/src/kafka-#{version}/config/server.properties.orig"
end

template "/tmp/kafka_config.sh" do
  source "kafka_config.sh.erb"
  mode "0755"
  owner "root"
  variables ({ :broker_id => node[:kafka][:broker_id],
               :hostname => node[:kafka][:hostname],
               :log_dir => node[:kafka][:data_dir],
               :num_partitions => node[:kafka][:num_partitions],
               :zk_servers => node[:kafka][:zk_servers],
               :filename_in => "/opt/src/kafka-#{version}/config/server.properties.orig",
               :filename_out => "/opt/src/kafka-#{version}/config/server.properties.tmp"
             })

end

bash "update-server-config" do
  code <<EOH
/tmp/kafka_config.sh && \
cp /opt/src/kafka-#{version}/config/server.properties.tmp \
   /opt/src/kafka-#{version}/config/server.properties
EOH
  subscribes :run, resources(:template => "/tmp/kafka_config.sh"), :immediately
  notifies :restart, "service[kafka]"
end

# Create an upstart config file
template "/etc/init/kafka.conf" do
  source "upstart.conf.erb"
  owner "root"
  mode "0644"
  variables({ :java_home => "/usr/lib/jvm/default-java/jre", # XXX
              :kafka_dir => "/opt/src/kafka-#{version}"
            })
end

# Register
service 'kafka' do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
