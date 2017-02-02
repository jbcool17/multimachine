require 'net/ssh'
require 'net/scp'
require 'colorize'
require_relative '../encode_nodes'

module RelationshipOfCommand
  module Utilities
    include RelationshipOfCommand::EncodeNodes

    def message(m)
      puts "===> #{m}".yellow
    end

    def connect_to_all(command)
      status = []

  		self.encoders.each do |node|
        message "Connecting to #{node[1].ip}...".blue

        Net::SSH.start(node[1].ip, node[1].user, :password => node[1].pass) do |ssh|
    			message "Logged in to #{ssh.exec!('hostname')}".blue
          s = ssh.exec!(command)
          status << {node.first => s}
    			message "#{s}".green
    			message "Logging out of #{ssh.exec!('hostname')}".blue
    		end
  		end

      # {:master=>["995", "1100"]}{:node1=>["1003", "1077"]}{:node2=>["997", "1116"]}{:node3=>["992", "1077"]}
      status
  	end

  	def connect_to(name, command)
  		node = self.encoders[name.to_sym]
      status = ''

      message "Connecting to #{node.ip}...".blue

      Net::SSH.start(node.ip, node.user, :password => node.pass) do |ssh|
  			message "Logged in to #{ssh.exec!('hostname')}".blue
        status = ssh.exec!(command)
  			message "#{status}".green
  			message "Logging out of #{ssh.exec!('hostname')}".blue
  		end

      status
  	end

    def transfer_to(name, local_path='testsrc1.mpg', remote_path='/home/vagrant/input')
      node = self.encoders[name.to_sym]
      progressbar = ProgressBar.create(title: "#{name}: TRANSFER ===>", length: 100, format: "%t |%B| %P%%",:progress_mark  => '#')
      Net::SCP.upload!(node.ip, node.user, local_path, remote_path) do |ch, name, sent, total|
        progressbar.progress = sent.fdiv(total) * 100
      end

      # 100.0
      progressbar.progress
    end

    def transfer_to_output(name, remote_path='output/testsrc.mov', local_path="#{`pwd`.strip}/")
      node = self.encoders[name.to_sym]
      progressbar = ProgressBar.create(title: "#{name}: TRANSFER ===>", length: 100, format: "%t: |%B| %P%%", :progress_mark  => '#')
      Net::SCP.download!(node.ip, node.user, remote_path, "#{local_path}#{remote_path}") do |ch, name, sent, total|
        progressbar.progress = sent.fdiv(total) * 100
      end

      # 100.0
      progressbar.progress
    end

    def run_command(name, command)
      node = self.encoders[name.to_sym]
      Net::SSH.start(node.ip, node.user, :password => node.pass) do |ssh|
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

      "COMMAND: #{command}"
    end
  end
end
