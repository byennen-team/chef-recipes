list = case node.platform
when "ubuntu" then
  %w(xserver-xorg-core xvfb)
when "centos" then
  %w(xorg-x11-server-Xvfb mesa-libGL)
end

list.each { |pkg| package(pkg) { action :install } }

cookbook_file "/etc/init/xvfb.conf" do
  owner "root"
  group "root"
  mode 0644
  source "xvfb.conf"
  variables ({
    :display_size => "#{node['xvfb']['display_size']}",
    :display => "#{node['xvfb']['display']}",
    :screen => "#{node['xvfb']['screen']}"})
  notifies(:restart, "service[xvfb]")
end

service "xvfb" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true
  action [:enable, :start]
end