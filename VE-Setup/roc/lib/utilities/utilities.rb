require 'net/ssh'
require 'net/scp'
require 'colorize'
require_relative '../encode_nodes'
require 'ruby-progressbar'
require 'sqlite3'

module RelationshipOfCommand
  module Utilities
    include RelationshipOfCommand::EncodeNodes

    def message(node, m)
      output = "#{node}: ===> #{m}"
      puts output

      return output
    end

    #----------------------------------------------------
    # DATABASE
    #----------------------------------------------------

    def delete_all_rows
      db = SQLite3::Database.new "db/test.db"
      db.execute("DELETE FROM jobs;")
    end

    def get_all_jobs
      out = {}
      db = SQLite3::Database.new "db/test.db"
      db.execute( "select * from jobs" ) do |row|
        out[row[0]] = [row[1], row[2], row[3], row[4], row[5]]
      end

      out
    end

    def get_jobs_in_ready
      out = {}
      db = SQLite3::Database.new "db/test.db"
      db.execute( "select * from jobs" ) do |row|
        out[row[0]] = [row[1], row[2], row[3], row[4], row[5]]
      end

      out.select! do |k,v|
        v[3] == 'ready'
      end

      out
    end

    def change_status(job_number, status, node)
      db = SQLite3::Database.new "db/test.db"

      db.execute("UPDATE jobs SET status=\'#{status}\' WHERE job_number=#{job_number};")
      db.execute("UPDATE jobs SET node=\'#{node}\' WHERE job_number=#{job_number};")
    end

    def create_jobs_table
      db = SQLite3::Database.new "db/test.db"
      db.execute <<-SQL
        create table jobs (
          job_number int,
          input_file varchar(50),
          output_file varchar(50),
          options varchar(50),
          status varchar(50),
          node varchar(50)
        );
      SQL
    end

    #----------------------------------------------------
    # SSH/SCP
    #----------------------------------------------------

    def connect_to_all(command)
      status = []

  		self.encoders.each do |node|
        name = node[0]
        message name, "Connecting to #{node[1].ip}...".blue

        Net::SSH.start(node[1].ip, node[1].user, :password => node[1].pass) do |ssh|
    			message name, "Logged in to #{ssh.exec!('hostname')}".strip.blue
          message name, "Running command: #{command}".strip.blue
          s = ssh.exec!(command)
          status << {node.first => s}
    			message name, "#{s}".green
    			message name, "Logging out of #{ssh.exec!('hostname')}".strip.blue
    		end
        message name, " "
  		end

      # {:master=>["995", "1100"]}{:node1=>["1003", "1077"]}{:node2=>["997", "1116"]}{:node3=>["992", "1077"]}
      status
  	end

  	def connect_to(name, command)
  		node = self.encoders[name.to_sym]
      status = ''

      message name, "Connecting to #{node.ip}...".blue

      Net::SSH.start(node.ip, node.user, :password => node.pass) do |ssh|
  			message name, "Logged in to #{ssh.exec!('hostname')}".strip.blue
        message name, "Running command: #{command}".strip.blue
        status = ssh.exec!(command)
  			message name, "#{status}".strip.green
  			message name, "Logging out of #{ssh.exec!('hostname')}".strip.blue
  		end

      message name, " "

      status
  	end

    def transfer_to(name, local_path='testsrc1.mpg', remote_path='/home/vagrant/input')
      node = self.encoders[name.to_sym]
      progressbar = ProgressBar.create(title: "#{name}: TRANSFER ===>", length: 100, format: "%t |%B| %P%%",:progress_mark  => '#')
      Net::SCP.upload!(node.ip, node.user, local_path, remote_path, :ssh => { :password => node.pass }) do |ch, name, sent, total|
        progressbar.progress = sent.fdiv(total) * 100
      end

      # 100.0
      progressbar.progress
    end

    def transfer_to_output(name, remote_path='output/testsrc.mov', local_path="./")
      node = self.encoders[name.to_sym]
      progressbar = ProgressBar.create(title: "#{name}: TRANSFER ===>", length: 100, format: "%t: |%B| %P%%", :progress_mark  => '#')
      puts "#{local_path}#{remote_path}"
      Net::SCP.download!(node.ip, node.user, remote_path, "#{local_path}#{remote_path}", :ssh => { :password => node.pass }) do |ch, name, sent, total|
        progressbar.progress = sent.fdiv(total) * 100
      end

      # 100.0
      progressbar.progress
    end

    def run_command(name, command)
      node = self.encoders[name.to_sym]
      Net::SSH.start(node.ip, node.user, :password => node.pass) do |ssh|
        channel = ssh.open_channel do |ch|
          message name, "Running command: #{command}".strip.blue
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
