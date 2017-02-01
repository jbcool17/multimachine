require 'net/ssh'
require 'net/scp'

module VE
  module Utilities
    def self.message(m)
      puts "===> #{m}"
    end

    def self.connect_to_all(command)
  		EncodeNodes.encoders.each do |node|
        message "Connecting to #{node[1][:ip]}...".blue

        Net::SSH.start(node[1][:ip], node[1][:user], :password => node[1][:pass]) do |ssh|
    			message "Logged in to #{ssh.exec!('hostname')}".blue
    			message "#{ssh.exec!(command)}".green
    			message "Logging out of #{ssh.exec!('hostname')}".blue
    		end
  		end
  	end

  	def self.connect_to(name, command)
  		node = EncodeNodes.encoders[name.to_sym]

      message "Connecting to #{node[:ip]}...".blue

      Net::SSH.start(node[:ip], node[:user], :password => node[:pass]) do |ssh|
  			message "Logged in to #{ssh.exec!('hostname')}".blue
  			message "#{ssh.exec!(command)}".green
  			message "Logging out of #{ssh.exec!('hostname')}".blue
  		end
  	end

    def self.transfer_to(name, local_path='testsrc1.mpg', remote_path='/home/vagrant/input')
      node = EncodeNodes.encoders[name.to_sym]
      progressbar = ProgressBar.create(title: 'TRANSFER ===>', length: 100, format: "%t |%B| %P%%",:progress_mark  => '#')
      Net::SCP.upload!(node[:ip], node[:user], local_path, remote_path) do |ch, name, sent, total|
        progressbar.progress = sent.fdiv(total) * 100
      end
    end

    def self.transfer_to_output(name, remote_path='output/testsrc.mov', local_path="#{`pwd`.strip}/output/testsrc.mov")
      node = EncodeNodes.encoders[name.to_sym]
      progressbar = ProgressBar.create(title: 'TRANSFER ===>', length: 100, format: "%t: |%B| %P%%", :progress_mark  => '#')
      Net::SCP.download!(node[:ip], node[:user], remote_path, local_path) do |ch, name, sent, total|
        progressbar.progress = sent.fdiv(total) * 100
      end

    end

    def self.run_command(name, command)
      node = EncodeNodes.encoders[name.to_sym]
      Net::SSH.start(node[:ip], node[:user], :password => node[:password]) do |ssh|
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
  end
end
