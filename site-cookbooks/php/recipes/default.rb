#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#php init-libraryも参照
%w{autoconf automake libxslt1-dev re2c curl libxml2-dev php5-dev php5 libbz2-dev libreadline6-dev libcurl4-gnutls-dev}.each do |pkg|
    package pkg do
        action:install
    end
end


bash "phpbrew install" do
  user "root"
  group "root"
  not_if { File.exist?("/usr/local/bin/phpbrew") }
  code <<-EOC
    sudo wget https://raw.github.com/c9s/phpbrew/master/phpbrew --no-check-certificate --output-document=/usr/local/bin/phpbrew
    sudo chmod +x /usr/local/bin/phpbrew
    sudo chmod 777 /usr/lib/apache2/modules/
    sudo chmod 777 /etc/apache2/mods-available/
  EOC
  action :run
end


bash "phpbrew setup and setup php5.5" do
  user "hirobanex"
  group "hirobanex"
  not_if { File.exist?("/home/hirobanex/.phpbrew/bashrc") }
  environment 'HOME' => "/home/hirobanex"
  #configureのoptionはec-cube仕様
  code <<-EOC
        cd /home/hirobanex
        /usr/local/bin/phpbrew init
        /usr/local/bin/phpbrew install php-5.5.13 +default +mb +dbs +session +zlib +openssl +curl +hash +apxs2 +gd -- --with-gd=shared --enable-gd-native-ttf --with-jpeg-dir=/usr/lib/x86_64-linux-gnu --with-png-dir=/usr/lib/x86_64-linux-gnu --with-freetype-dir=/usr/include/feeetype2/freetype --with-mysql-sock=/var/run/mysqld/mysqld.sock
        /usr/local/bin/phpbrew switch php-5.5.13
        /usr/local/bin/phpbrew ext install gd
  EOC
  action :run
  notifies :restart, 'service[apache2]'
end

bash "composer install" do
  user "root"
  group "root"
  not_if { File.exist?("/usr/local/bin/composer") }
  environment 'HOME' => "/home/hirobanex"
  code <<-EOC
        cd /home/hirobanex
        curl -sS https://getcomposer.org/installer | php
        mv composer.phar /usr/local/bin/composer
  EOC
  action :run
end
