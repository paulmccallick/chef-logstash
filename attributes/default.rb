# Encoding: utf-8

default['logstash']['version']        = '1.4.2'
default['logstash']['source_url']     = 'https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz'
default['logstash']['checksum']       = 'd5be171af8d4ca966a0c731fc34f5deeee9d7631319e3660d1df99e43c5f8069'

default['logstash']['instance_default']['plugins_version']        = '1.4.2'
default['logstash']['instance_default']['plugins_source_url']     = 'https://download.elasticsearch.org/logstash/logstash/logstash-contrib-1.4.2.tar.gz'
default['logstash']['instance_default']['plugins_checksum']       = '7497ca3614ba9122159692cc6e60ffc968219047e88de97ecc47c2bf117ba4e5'

default['logstash']['inputs'] = []
default['logstash']['filters'] = []
default['logstash']['outputs'] = []
