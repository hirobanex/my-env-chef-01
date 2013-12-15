#
# Cookbook Name:: aptitude
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#



#script "update" do
#  interpreter "bash"
##  user        "root"
#  code <<-EOL
#    aptitude update
#  EOL
#end

package "aptitude" do
    action :upgrade
end



