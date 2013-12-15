#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

##インストゥール
%w{mysql-server-5.5 mysql-client libmysqlclient-dev}.each do |pkg|
    package pkg do
        action:install
    end
end

##起動
service "mysql" do
    action [ :start ]
    supports :status => true, :restart => true
end

##設定 存在チェックと削除チェックが微妙だけどなんとなくこれで現実的にはオッケー
bash "innodb_env_change" do
  user "root"
  group "root"
  only_if { File.exist?("/var/lib/mysql/ib_logfile0") || File.exist?("/var/lib/mysql/ib_logfile1") }
  code <<-EOC
    mysql -uroot -ptest -e "SET GLOBAL innodb_fast_shutdown=0;"
    rm /var/lib/mysql/ib_logfile0
    rm /var/lib/mysql/ib_logfile1
  EOC
  action :nothing
#  subscribes :run, resources(:template => "my.cnf") notifiesにした
end

template "my.cnf" do
    path "/etc/mysql/my.cnf"
    source "my.cnf.erb"
    owner "root"
    group "root"
    mode 00644
    notifies :run, 'bash[innodb_env_change]'
    notifies :restart, 'service[mysql]'
end
