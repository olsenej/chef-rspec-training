#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

package "apache2"

# This is the magical one liner that allows you to halt the tests and examine the recipe.
# require 'pry' ; binding.pry

index_filepath = "/var/www/html/index.html"
if node["platform_version"] == "12.04"
  index_filepath = "/var/www/index.html"
end

file index_filepath do
  owner "root"
  group "root"
  mode "0644"
  content "Hello, world!"
end

service "apache2" do
  action [ :start, :enable ] 
end

config_filepath = "/etc/apache2/conf-enabled"

if node["platform_version"] == "12.04"
  config_filepath = "/etc/apache2/conf.d"
end

template "#{config_filepath}/admin.conf" do
  source "config.erb"
  variables(port: 8080,document_root: "/var/www/admin/html")
  notifies :restart, "service[apache2]"
end

directory "/var/www/admin/html" do
  recursive true
end

file "/var/www/admin/html/index.html" do
  content "Welcome Admin!"
end

#Power Users, 8000
apache_vhost "powerusers" do
  config_file "#{config_filepath}/powerusers.conf"
  config_filepath "#{config_filepath}"
  port 8000
  # document_root "/var/www/powerusers/html"
  content "Hello power users"
  notifies :restart, "service[apache2]"
  action :create
end

#SuperLions, 7000
apache_vhost "superlions" do
  config_file "#{config_filepath}/superlions.conf"
  config_filepath "#{config_filepath}"
  port 7000
  # document_root "/var/www/superlions/html"
  content "Hey it's superlions"
  notifies :restart, "service[apache2]"
  action :create
end


#Template with power user path and port 8000
#template "#{config_filepath}/power.conf" do
#  source "power.erb"
#  variables(port: 8000, document_root: "/var/www/power/html")
#  notifies :restart, "service[apache2]"
#end

#Create dir for html
#directory "/var/www/power/html" do
#  recursive true
#end

#Create index html
#file "/var/www/power/html/index.html" do
#  content "Hello power users"
#end




