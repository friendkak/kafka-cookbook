# XXX: TODO


zookeeper_pairs = wait_for("Zookeeper", node[:kafka][:zookeeper_boxes], 10) { fqdns_for_role("#{node[:kafka][:zookeeper_role]}") }
i = 0
while i < zookeeper_pairs.size do
  zookeeper_pairs[i] = zookeeper_pairs[i].concat(":2181")
  i += 1
end
