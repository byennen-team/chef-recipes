include_recipe 'selenium::default'

directory node['selenium']['server']['installpath']

cookbook_file File.join(node['selenium']['server']['installpath'], 'selenium-standalone-hub.jar') do
  source "selenium-standalone-hub.jar"
  action :create
  mode 0644
end

template "/etc/init/selenium-hub.conf" do
  source "hub.erb"
  mode 0644
  variables ({
    :xmx => "#{node['selenium']['hub']['memory']}",
    :selenium_hub => File.join(node['selenium']['server']['installpath'], 'selenium-standalone-hub.jar'),
    :options => "#{node['selenium']['hub']['options']}",
    :log => File.join(node['selenium']['server']['logpath'], 'hub.log')})
end

service "selenium-hub" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true
  action [:enable, :start]
end

# logrotate
template "/etc/logrotate.d/selenium_hub" do
  source "logrotate.d/hub.erb"
  owner "root"
  group "root"
  mode "0644"
end