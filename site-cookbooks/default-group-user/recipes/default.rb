#
# Cookbook Name:: default-group-user
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#data bagsに移動か？？？ cookbook_fileのやつをどうすればよいかよくわからん。:

group 'hirobanex' do
  group_name 'hirobanex'
  gid        1001
  action     [:create]
end

#groupにsudo権限を与える構文を書く
#cookbook_file "/etc/sudoers" do
#  mode 00440
#  checksum "50ad7838d3fe69c9610cf7e214f902dc0a4045f54a0eeff0b62207299289904e" #shasum -a 256 xxxxx
#end

user 'hirobanex' do
  comment  'hirobanex'
  uid      2001
  group    'hirobanex'
  home     '/home/hirobanex/'
  shell    '/usr/bin/zsh'
  password '$1$TfCm0J17$CHO8ldfm9tN/3mzLKjeVA0'
  supports :manage_home => true
  action   [:create,]
end

#userのホームディレクトリ配下にデフォルトでおいておきたいコンフィグファイルをおいておく
directory '/home/hirobanex/.ssh' do
  not_if { File.exist?("/home/hirobanex/.ssh") }
  owner "hirobanex"
  group "hirobanex"
  mode '0700'
end

execute "generate ssh skys" do
  user "hirobanex"
  creates "/home/hirobanex/.ssh/id_rsa.pub"
  command "ssh-keygen -t rsa -q -f /home/hirobanex/.ssh/id_rsa -P \"\""
end

cookbook_file "/home/hirobanex/.ssh/authorized_keys" do
  owner "hirobanex"
  group "hirobanex"
  mode 0600
end


directory '/home/hirobanex/project/' do
  not_if { File.exist?("/home/hirobanex/project/") }
  owner "hirobanex"
  group "hirobanex"
  mode '0755'
end

cookbook_file "/home/hirobanex/.gitconfig" do
  owner "hirobanex"
  group "hirobanex"
  source "gitconfig"
  mode 0644
end

cookbook_file "/home/hirobanex/.gitignore" do
  owner "hirobanex"
  group "hirobanex"
  source "gitignore"
  mode 0644
end

cookbook_file "/home/hirobanex/.screenrc" do
  owner "hirobanex"
  group "hirobanex"
  source "screenrc"
  mode 0644
end

cookbook_file "/home/hirobanex/.vimrc" do
  owner "hirobanex"
  group "hirobanex"
  source "vimrc"
  mode 0644
end

cookbook_file "/home/hirobanex/.zshrc" do
  owner "hirobanex"
  group "hirobanex"
  source "zshrc"
  mode 0644
end

cookbook_file "/home/hirobanex/.ssh/config" do
  owner "hirobanex"
  group "hirobanex"
  mode 0644
  source "ssh-local-config"
end


