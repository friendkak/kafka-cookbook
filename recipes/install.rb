#
# Cookbook Name:: kafka
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "/opt/src" do
  action :create
  recursive true
end

version = node[:kafka][:version]
url = node[:kafka][:mirror].gsub("{version}", version)

remote_file "/opt/src/kafka-#{version}-src.tgz" do
  source url
  mode "0644"
  checksum node[:kafka][:sha256sum]
end

execute "Untar Kafka" do
  command "tar -zxf /opt/src/kafka-#{version}-src.tgz -C /opt/src/"
  action :run
  creates "/opt/src/kafka-#{version}"
end

bash "sbt update" do
  code <<EOH
export PATH=$PATH:/usr/lib/jvm/default-java/bin/
/bin/bash sbt update
EOH
  action :run
  cwd "/opt/src/kafka-#{version}"
  creates "/opt/src/kafka-#{version}/lib_managed"
end

bash "sbt package" do
  code <<EOH
export PATH=$PATH:/usr/lib/jvm/default-java/bin/
/bin/bash sbt package
EOH
  action :run
  cwd "/opt/src/kafka-#{version}"
  creates "/opt/src/kafka-#{version}/perf/target"
end

directory "/var/log/kafka" do
  mode "0755"
  action :create
end

logrotate_app "kafka" do
  cookbook "kafka"
  template "kafka-rotate.erb"
  path [ "/var/log/kafka/*.log" ]
  frequency node[:kafka][:logrotate_freq]
  create "644 root root"
  rotate node[:kafka][:logrotate_rotate]
end
