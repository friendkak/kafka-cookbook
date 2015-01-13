default[:kafka][:version] = '0.7.1-incubating'
default[:kafka][:mirror] = 'http://archive.apache.org/dist/kafka/old_releases/kafka-{version}/kafka-{version}-src.tgz'
default[:kafka][:sha256sum] = "99ec0641de3646229c1a598023274b22d4229f21cd7f95d7043494a249bdc3c3"

# Where to store the commitlogs. NOTE: This should be changed
default[:kafka][:data_dir] = "/tmp/kafka-logs"

default[:kafka][:logrotate_freq] = 'daily'
default[:kafka][:logrotate_rotate] = 14

default[:kafka][:log_retention_hours] = 96

default[:kafka][:zk_servers] = ['localhost:2181']

default[:kafka][:broker_id] = 0
default[:kafka][:num_partitions] = 1
default[:kafka][:hostname] = nil

#default[:kafka][:zk_root] = "kafka"
