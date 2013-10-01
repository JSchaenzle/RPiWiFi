#network_manager.rb
require 'erb'

VERSION = "1.0.0"

DEFAULT_SETTINGS = { 
	rpi_wifi_version: VERSION,
	infstr: { ssid: "DON'T STEAL MY INTERNET",
			  passkey: "8983143239" },
	ad_hoc: { subnet: "255.255.255.0",
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
		convert_template_to_file('./templates/ad_hoc/dhcpd.conf.erb', '/etc/dhcp/dhcpd.conf')
		convert_template_to_file('./templates/ad_hoc/interfaces.erb', '/etc/network/interfaces')
	end

	def self.config_infrastructure_network(ssid, pwd, sec_type)
		convert_template_to_file('./templates/infstr/interfaces.erb', '/etc/interfaces')
		convert_template_to_file('./templates/infstr/wpa_supplicant.erb', '/etc/dhcp/dhcpd.conf')
	end

	def self.is_connected
	end
  
	def self.get_network_list
		scan_results = `iwlist wlan0 scan`
		available_networks = scan_results.scan(/ESSID:\"(.+)\"/).flatten
	end

	def convert_template_to_file(template, output)
		foo = ERB.new File.read(template)
		File.open(output, "w+") do |f|
			f.write foo.result(binding)
		end
	end

end


