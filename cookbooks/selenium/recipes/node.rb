include_recipe "selenium::default"
package "xvfb"

directory node['selenium']['server']['installpath']

cookbook_file File.join(node['selenium']['server']['installpath'], 'selenium-server-standalone-2.42.2.jar') do
  source "selenium-server-standalone-2.42.2.jar"
  action :create
  mode 0644
end

template "/etc/selenium/node.json" do
 source "node.json.erb"
   mode 0644
   variables ({
   :ffversion => "#{node['selenium']['firefox']['version']}",
   :ffmaxinstances => "#{node['selenium']['firefox']['maxInstances']}",
   :operaversion => "#{node['selenium']['opera']['version']}",
   :operamaxinstances => "#{node['selenium']['opera']['maxInstances']}",
   :chromeversion => "#{node['selenium']['chrome']['version']}",
   :chromemaxinstances => "#{node['selenium']['chrome']['maxInstances']}",
   :htmlunitversion => "#{node['selenium']['htmlunit']['version']}",
   :htmlunitmaxinstances => "#{node['selenium']['htmlunit']['maxInstances']}"})
end

template "/etc/init/selenium-node.conf" do
  source "node.erb"
  mode 0644
  variables ({
    :fbsize => "#{node['selenium']['xvfb']['fbsize']}",
    :xmx => "#{node['selenium']['node']['memory']}",
    :chromedriver => File.join(node['selenium']['chromedriver']['installpath'], 'chromedriver'),
    :config => File.join(node['selenium']['server']['confpath'], 'node.json'),
    :selenium => File.join(node['selenium']['server']['installpath'], 'selenium-server-standalone-2.42.2.jar'),
    :host => "#{node['selenium']['hub']['host']}",
    :port => "#{node['selenium']['hub']['port']}",
    :log => File.join(node['selenium']['server']['logpath'], 'node.log')})
end

service "selenium-node" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true
  action [:enable, :start]
end