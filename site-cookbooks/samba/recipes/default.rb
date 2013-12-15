#
# Cookbook Name:: samba
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
##設定
package "samba" do
    action:install
end

##起動
service "smbd" do
    action [ :enable, :start ]
    supports :restart => true
end

##設定

template "smb.conf" do
    path "/etc/samba/smb.conf"
    source "smb.conf"
    owner "root"
    group "root"
    mode 0644
    notifies :restart, 'service[smbd]'
end

