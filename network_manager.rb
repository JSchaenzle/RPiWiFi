#network_manager.rb
require 'erb'
VERSION = "1.0.0"

class NetworkManager
  
	def self.reset_to_ad_hoc
	end

	def self.config_infrastructure_network(ssid, pwd, sec_type)
	end

	def self.is_connected
	end
  
	def self.get_network_list
		scan_results = `iwlist wlan0 scan`
		available_networks = scan_results.scan(/ESSID:\"(.+)\"/).flatten
	end

end

settings = {rpi_wifi_version: VERSION}
settings[:ssid] = "DON'T STEAL MY INTERNET"
settings[:passkey] = "8983143239"

foo = ERB.new File.read('./templates/infstr_wpa_supplicant.conf.erb')

output = File.new('./wpa_supplicant.conf', "w+")
output.write foo.result
