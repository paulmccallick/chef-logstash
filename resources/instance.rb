# Encoding: utf-8
# Cookbook Name:: logstash
# Resource:: instance
# Author:: John E. Vincent
# Copyright 2014, John E. Vincent
# License:: Apache 2.0

actions :create, :delete

default_action :create if defined?(default_action)

attribute :provider, default: Chef::Provider::LogstashInstanceTarball
attribute :name, kind_of: String, name_attribute: true, default: 'default'
attribute :base_directory, kind_of: String, default: '/opt/logstash'
attribute :auto_symlink, kind_of: [TrueClass, FalseClass], default: true
# version/checksum/source_url used by `jar`, `tarball` install_type
attribute :version, kind_of: String, default: '1.4.2'
attribute :checksum, kind_of: String, default: 'd5be171af8d4ca966a0c731fc34f5deeee9d7631319e3660d1df99e43c5f8069'
attribute :source_url, kind_of: String, default: 'https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz'

# sha/repo/java_home used by `source` install_type
attribute :sha, kind_of: String, default: 'HEAD'
attribute :repo, kind_of: String, default: 'git://github.com/logstash/logstash.git'
attribute :java_home, kind_of: String, default: '/usr/lib/jvm/java-6-openjdk'
attribute :user, kind_of: String, default: 'logstash'
attribute :group, kind_of: String, default: 'logstash'
attribute :create_account, kind_of: [TrueClass, FalseClass], default: true
attribute :logrotate_enable, kind_of: [TrueClass, FalseClass], default: true
attribute :user_opts, kind_of: [Hash], default: { homedir: '/var/lib/logstash', uid: nil, gid: nil }
attribute :logrotate_size, kind_of: [String], default: '10M'
attribute :logrotate_use_filesize, kind_of: [TrueClass, FalseClass], default: false
attribute :logrotate_frequency, kind_of: [String], default: 'daily'
attribute :logrotate_max_backup, kind_of: [Integer], default: 10
attribute :logrotate_options, kind_of: [Array], default: %w(missingok notifempty compress copytruncate)

