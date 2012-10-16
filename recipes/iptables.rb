
include_recipe "iptables"

iptables_rule "kafka_broker" do
  source "iptables.erb"

  variables :port => 9092, :mx4j_port => 8082
end
