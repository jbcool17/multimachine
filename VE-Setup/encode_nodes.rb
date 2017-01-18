module EncodeNodes
	def self.encoders
	return {
		node1: {ip: "192.168.56.111", user:'vagrant', pass:'vagrant'},
		node2: {ip: "192.168.56.112", user:'vagrant', pass:'vagrant'},
		node3: {ip: "192.168.56.113", user:'vagrant', pass:'vagrant'}
		}
	end
end
