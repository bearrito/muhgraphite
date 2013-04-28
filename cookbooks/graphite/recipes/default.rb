#
# Cookbook Name:: graphite
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

service "nginx" do
  action :nothing
  supports :status => true, :restart => true, :reload => true
end


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
template local_settings do
    source "local_settings.py.erb" 
end

chown_command = "chown -R #{node[:auth][:graphiteuser]}:#{node[:auth][:graphitegroup]} #{node[:install][:directory]}/graphite"
chmod_command = "chmod -R ug+s #{node[:install][:directory]}/graphite"


execute "chown_and_chmod" do
  command chown_command
  command chmod_command
end



directory "#{node[:install][:directory]}/graphite/storage/log/webapp}" do
  owner  node[:auth][:graphiteuser]
  group  node[:auth][:graphiteuser]
  mode   00644
  action :create
end


setup_db = "/tmp/setup_db.py"
template setup_db do
    source "setup_db.py.erb" 
end

setup_db_command = "python /tmp/setup_db.py"
execute setup_db_command do
   command setup_db_command
   returns 1
end


node[:graphite][:initscripts].each do |init| 
    
    startup = "/etc/init.d/#{init}"
    template startup do
      source "#{init}.erb"
    end
  
    chmod_startup = "chmod ugo+x #{startup}"
    execute "chown the inits" do
        command chmod_startup
    end

    execute "set_event" do
        command "update-rc.d #{init} defaults" 
        cwd "/etc/init.d/"
    end

end 

template "/etc/nginx/nginx.conf" do
   source "nginx.conf.erb"
   notifies :restart, resources(:service => "nginx")

end


node[:graphite][:supervisorscripts].each do |svisor|

    template  "/etc/supervisor/conf.d/#{svisor}" do
      source "#{svisor}.erb"
    end
end

execute "start_services" do
   command "supervisorctl update && supervisorctl start uwsgi"
   command "/etc/init.d/carbon start"
   command "nginx"
end





