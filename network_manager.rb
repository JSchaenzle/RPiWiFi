#network_manager.rb
require 'erb'

VERSION = "1.0.0"

DEFAULT_SETTINGS = { 
	rpi_wifi_version: VERSION,

	infstr: { key_mgmt: "WPA-PSK"
			  ssid: "Secure Network",
			  passkey: "123456" },

	ad_hoc: { subnet: "192.168.1.0",
			  netmask: "255.255.255.0",
			  ip_range_min: "192.168.1.5",
			  ip_range_max: "192.168.1.150" }
}

class NetworkManager

	def initialize
		@settings = DEFAULT_SETTINGS
	end

	def settings
		return @settings
	end

	def reset_to_ad_hoc
		# Load the config files from the templates
		convert_template_to_file('./templates/ad_hoc/dhcpd.conf.erb', '/etc/dhcp/dhcpd.conf')
		convert_template_to_file('./templates/ad_hoc/interfaces.erb', '/etc/network/interfaces')
		restart_dhcp
		restart_network
	end

	def connect_to_infstr_network
		convert_template_to_file('./templates/infstr/interfaces.erb', '/etc/network/interfaces')
		convert_template_to_file('./templates/infstr/wpa_supplicant.conf.erb', '/etc/dhcp/dhcpd.conf')
		restart_network
		stop_dhcp
	end

	def self.is_connected
		"wpa_cli status"
	end
  
	def self.get_network_list
		# More info with "wpa_cli scan" and "wpa_cli scan_results"
		scan_results = `iwlist wlan0 scan`
		available_networks = scan_results.scan(/ESSID:\"(.+)\"/).flatten
	end

	def convert_template_to_file(template, output)
		foo = ERB.new File.read(template)
		File.open(output, "w+") do |f|
			f.write foo.result(binding)
		end
	end

	def restart_dhcp
		system("service isc-dhcp-server stop")
		system("service isc-dhcp-server start")
	end

	def stop_dhcp
		system("service isc-dhcp-server stop")
	end

	def restart_network
		system("ifdown --force wlan0")
		system("ifup wlan0")
	end

end


