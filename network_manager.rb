#network_manager.rb

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


# Get the network types



