#
# Cookbook Name:: perl
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash "download from git" do
  user "hirobanex"
  group "hirobanex"
  not_if { File.exist?("/home/hirobanex/.plenv") }
  code <<-EOC
        git clone git://github.com/tokuhirom/plenv.git /home/hirobanex/.plenv
        git clone git://github.com/tokuhirom/Perl-Build.git /home/hirobanex/.plenv/plugins/perl-build/
  EOC
  action :run
end

bash "plenv setup and setup perl" do
  user "hirobanex"
  group "hirobanex"
  not_if { File.exist?("/home/hirobanex/.plenv/versions/5.14.1") }
  environment 'HOME' => "/home/hirobanex" 
  code <<-EOC
        /home/hirobanex/.plenv/bin/plenv rehash
        /home/hirobanex/.plenv/plugins/perl-build/bin/plenv-install 5.18.0
        /home/hirobanex/.plenv/bin/plenv global 5.18.0
        /home/hirobanex/.plenv/bin/plenv rehash
        /home/hirobanex/.plenv/bin/plenv install-cpanm
        /home/hirobanex/.plenv/bin/plenv rehash
   EOC
  action :run
end

