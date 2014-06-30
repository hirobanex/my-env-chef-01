#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

##設定
package "apache2" do
    action:install
end
package "apache2-dev" do
    action:install
end

##起動
service "apache2" do
    action [ :enable, :start, ]
    restart_command "sudo service apache2 graceful"
    supports :restart => true
end

##設定

bash "a2enmod write" do
  not_if { File.exist?("/etc/apache2/mods-enabled/rewrite.load") }
  code <<-EOC
    a2enmod rewrite
  EOC
  action :run
end

bash "a2enmod status" do
  not_if { File.exist?("/etc/apache2/mods-enabled/status.load") }
  code <<-EOC
    a2enmod status
  EOC
  action :run
end

template "status.conf" do
    path "/etc/apache2/mods-available/status.conf"
    source "status.conf"
    owner "root"
    group "root"
    mode 0644
    notifies :restart, 'service[apache2]'
end

bash "a2enmod headers" do
  not_if { File.exist?("/etc/apache2/mods-enabled/headers.load") }
  code <<-EOC
    a2enmod headers
  EOC
  action :run
end

bash "a2enmod proxy" do
  not_if { File.exist?("/etc/apache2/mods-enabled/proxy.load") }
  code <<-EOC
    a2enmod proxy
  EOC
  action :run
end

bash "a2enmod proxy_http" do
  not_if { File.exist?("/etc/apache2/mods-enabled/proxy_http.load") }
  code <<-EOC
    a2enmod proxy_http
  EOC
  action :run
end

