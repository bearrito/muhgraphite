#
# Cookbook Name:: graphite
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


user_home = "/home/#{node[:auth][:graphiteuser]}"
user node[:auth][:graphiteuser] do
  shell "/bin/bash"
  home user_home
  system false
  action :create
  supports :manage_home => true
end

group node[:auth][:graphitegroup] do
  action :create
  members node[:auth][:hduser]
  append true
end

carbon		= "#{node[:install][:directory]}/carbon"
whisper		= "#{node[:install][:directory]}/whisper"
graphite 	=  "#{node[:install][:directory]}/graphite"

node[:graphite][:packages][:deb].each do |pkg|
   package pkg do
      action :install
   end
end


node[:graphite][:packages][:pip].each do |mod|
    python_pip mod do
    action :install
    end
end



graph_conf = "#{node[:install][:directory]}/graphite/conf/carbon.conf"
template graph_conf do
    source "carbon.conf.erb" 
end


storage_schemas_conf = "#{node[:install][:directory]}/graphite/conf/storage-schemas.conf"
template storage_schemas_conf do
    source "storage-schemas.conf.erb" 
end


local_settings = "#{node[:install][:directory]}/graphite/webapp/graphite/local_settings.py"
template graph_conf do
    source "local_settings.py.erb" 
end


directory "#{node[:install][:directory]}/graphite/storage/log/webapp}" do
  owner  node[:auth][:graphiteuser]
  group  node[:auth][:graphiteuser]
  mode   00644
  action :create
end






