require_relative 'computer'
require 'dotenv'
Dotenv.load

module RelationshipOfCommand
	module EncodeNodes
		def encoders
			# m = RelationshipOfCommand::Master.new(ENV['ROC_MASTER_IP'], ENV['ROC_MASTER_USER'], ENV['ROC_MASTER_PASS'])
			n1 = RelationshipOfCommand::Node.new("192.168.56.111", ENV['ROC_NODE_USER'], ENV['ROC_NODE_PASS'])
			n2 = RelationshipOfCommand::Node.new("192.168.56.112", ENV['ROC_NODE_USER'], ENV['ROC_NODE_PASS'])
			n3 = RelationshipOfCommand::Node.new("192.168.56.113", ENV['ROC_NODE_USER'], ENV['ROC_NODE_PASS'])

			return { node1: n1, node2: n2, node3: n3 }
		end
	end
end
