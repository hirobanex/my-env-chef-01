#
# Cookbook Name:: init-libray
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{zsh vim screen git-core build-essential gcc g++ curl mcrypt git-core libmcrypt4 libmcrypt-dev language-pack-ja daemontools daemontools-run postfix nmap tree unzip}.each do |pkg|
    package pkg do
        action:install
    end
end


#imager
%w{libfreetype6 libfreetype6-dev libjpeg-dev libtiff-dev libpng-dev}.each do |pkg|
    package pkg do
        action:install
    end
end

bash "fluentd install" do
  user "root"
  group "root"
  not_if { File.exist?("/etc/td-agent/td-agent.conf") }
  code <<-EOC
    curl -L http://toolbelt.treasuredata.com/sh/install-ubuntu-precise.sh | sh
    sudo /usr/lib/fluent/ruby/bin/fluent-gem install fluent-plugin-rewrite
  EOC
  action :run
end
service "td-agent" do
    action [ :nothing ]
    supports :status => true, :restart => true
end

