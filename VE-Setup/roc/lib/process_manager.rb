require 'colorize'
require 'ruby-progressbar'
require_relative 'utilities/utilities'
require_relative 'encode_nodes'


module RelationshipOfCommand
  module ProcessManager
    include Utilities

    def check_for_processes(process_name)
      status = self.connect_to_all "pgrep -f #{process_name}"
      # kill -9 `pgrep -f keyword`
      node_status = {}
      status.each do |node|
        node_status[node.keys.first] = node.values.first.empty? ? true : false
      end

      # {:master=>true, :node1=>true, :node2=>true, :node3=>true}
      node_status
    end

  	def self.check_all_docker_processes
  		self.encoders.each do |e|
  			self.message "Connecting to #{e[1][:ip]}...".blue
  			Net::SSH.start(e[1][:ip], e[1][:user], :password => e[1][:pass]) do |ssh|
  				self.message "Logged in to #{ssh.exec!('hostname')}".blue

  				output = ssh.exec!('docker ps -a --format "{{.ID}} : {{.Names}} : {{.Image}} : {{.Status}}**>"')

  				if !output.empty?
  					info = {}
  					output.gsub("\n", '').split('**>').each do |line|
  						info[line.split(':')[0].strip] = line.split(':')[3].strip
  					end

  					@status = info

  					info.each do |k,v|
  						self.message "#{k.upcase} - #{v}".green
  						dc = 'docker logs -t --tail 1 ' + k
  						self.message "LAST LOG: #{ssh.exec!('docker logs -t --tail 1 ' + k)}"
  					end
  				else
  					self.message "No Processes Running.".yellow
  				end
  				self.message "Logging out...".blue
  			end
  		end
  	end
  end
end
