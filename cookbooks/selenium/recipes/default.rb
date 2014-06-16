#
# Cookbook Name:: selenium_hub
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

#
# Java Installation for selenium server.
#
package 'openjdk-7-jre-headless'

user node['selenium']['server']['user'] do
  home "/home/selenium"
  supports :manage_home => true
  action :create
end

directory node['selenium']['server']['logpath'] do
  owner node['selenium']['server']['user']
  recursive true
end

directory node['selenium']['server']['confpath'] do
  owner node['selenium']['server']['user']
  recursive true
end