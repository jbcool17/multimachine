require 'colorize'
require 'ruby-progressbar'
require_relative 'utilities/utilities'
require_relative 'encode_nodes'


module VE
  class ProcessManager
  	include EncodeNodes

  	def self.check_all_docker_processes
  		EncodeNodes.encoders.each do |e|
  			VE::Utilities.message "Connecting to #{e[1][:ip]}...".blue
  			Net::SSH.start(e[1][:ip], e[1][:user], :password => e[1][:pass]) do |ssh|
  				VE::Utilities.message "Logged in to #{ssh.exec!('hostname')}".blue

  				output = ssh.exec!('docker ps -a --format "{{.ID}} : {{.Names}} : {{.Image}} : {{.Status}}**>"')

  				if !output.empty?
  					info = {}
  					output.gsub("\n", '').split('**>').each do |line|
  						info[line.split(':')[0].strip] = line.split(':')[3].strip
  					end

  					@status = info

  					info.each do |k,v|
  						VE::Utilities.message "#{k.upcase} - #{v}".green
  						dc = 'docker logs -t --tail 1 ' + k
  						VE::Utilities.message "LAST LOG: #{ssh.exec!('docker logs -t --tail 1 ' + k)}"
  					end
  				else
  					VE::Utilities.message "No Processes Running.".yellow
  				end
  				VE::Utilities.message "Logging out...".blue
  			end
  		end

  	end

    def self.run_command(name, command)
  		e = EncodeNodes.encoders[name.to_sym]
  		Net::SSH.start(e[:ip], e[:user], :password => e[:password]) do |ssh|
        channel = ssh.open_channel do |ch|
          ch.exec command do |ch, success|
            raise "could not execute command" unless success

            # "on_data" is called when the process writes something to stdout
            ch.on_data do |c, data|
              $stdout.print data
            end

            # "on_extended_data" is called when the process writes something to stderr
            ch.on_extended_data do |c, type, data|
              $stderr.print data
            end

            # ch.on_close { puts "done!" }
          end
        end

        channel.wait
  		end
  	end

    def self.check_processes(process_name)
      # connect_to 'master', "pgrep -f #{process_name}"
      connect_to_all "pgrep -f #{process_name}"
      # kill -9 `pgrep -f keyword`
      @status.split(' ').each do |pid|
        run_command 'master', "ps h #{pid}"
      end
    end

    def self.connect_to_all(command)
      EncodeNodes.encoders.each do |e|
        VE::Utilities.message "Connecting to #{e[1][:ip]}...".blue
        Net::SSH.start(e[1][:ip], e[1][:user], :password => e[1][:pass]) do |ssh|
          VE::Utilities.message "Logged in to #{ssh.exec!('hostname')}".blue
          @status = ssh.exec!(command)
          VE::Utilities.message "#{@status}".green
          VE::Utilities.message "Logging out of #{ssh.exec!('hostname')}".blue
        end
      end
    end

    def self.connect_to(name, command)
  		e = EncodeNodes.encoders[name.to_sym]
  		VE::Utilities.message "Connecting to #{e[:ip]}...".blue
  		Net::SSH.start(e[:ip], e[:user], :password => e[:pass]) do |ssh|
  			VE::Utilities.message "Logged in to #{ssh.exec!('hostname')}".blue
          status = ssh.exec!(command)
  			VE::Utilities.message "#{status}".green
  			VE::Utilities.message "Logging out of #{ssh.exec!('hostname')}".blue
  		end
  	end
  end
end