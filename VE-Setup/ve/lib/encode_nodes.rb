require_relative 'computer'
require 'dotenv'
Dotenv.load

module RelationshipOfCommand
	module EncodeNodes
		def encoders
			m = RelationshipOfCommand::Master.new(ENV['MASTER_IP'], ENV['MASTER_USER'], ENV['MASTER_PASS'])
			n1 = RelationshipOfCommand::Node.new("192.168.56.111", 'vagrant', 'vagrant')
			n2 = RelationshipOfCommand::Node.new("192.168.56.112", 'vagrant', 'vagrant')
			n3 = RelationshipOfCommand::Node.new("192.168.56.113", 'vagrant', 'vagrant')

			return { master: m, node1: n1, node2: n2, node3: n3 }
		end
	end
end
