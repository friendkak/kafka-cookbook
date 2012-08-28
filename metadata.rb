maintainer       "ehauser@exacttarget.com"
maintainer_email "Eric Hauser"
license          "Apache 2.0"
description      "Installs/Configures kafka"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends "java"
depends "logrotate"
depends "service_discovery"

recipe "kafka::install", "Install Apache Kafka"
recipe "kafka::config", "Configure Apache Kafka"
