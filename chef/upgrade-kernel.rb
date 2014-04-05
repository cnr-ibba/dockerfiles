
case node['platform']
when 'centos', 'redhat', 'fedora'
	execute "Upgrading distro to latest version" do
		command "yum -y upgrade"
	end
when 'debian', 'ubuntu'
	include_recipe 'apt'
	pkgs = %w(linux-image-generic-lts-raring linux-headers-generic-lts-raring)
	pkgs.each do |pkg|
		apt_package pkg do
			action :install
		end
	end
end

