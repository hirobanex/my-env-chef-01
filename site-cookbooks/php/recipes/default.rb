#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#php init-libraryも参照
%w{autoconf automake libxslt1-dev re2c curl libxml2-dev php5-dev php5 libbz2-dev libreadline6-dev}.each do |pkg|
    package pkg do
        action:install
    end
end


bash "phpbrew install" do
  user "root"
  group "root"
  not_if { File.exist?("/usr/local/bin/phpbrew") }
  code <<-EOC
    wget https://raw.github.com/c9s/phpbrew/master/phpbrew --no-check-certificate --output-document=/usr/local/bin/phpbrew
    chmod +x /usr/bin/phpbrew
    chmod 777 /usr/lib/apache2/modules/
    chmod 777 /etc/apache2/mods-available/
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
        phpbrew init
        phpbrew install php-5.5.13 +default +mb +dbs +session +session +zlib +openssl +curl +hash +apxs2
        phpbrew switch php-5.5.13
  EOC
  action :run
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
