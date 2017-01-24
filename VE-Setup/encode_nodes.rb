module EncodeNodes
	def self.encoders
	return {
		node1: {ip: "192.168.56.100", user:'vagrant', pass:'vagrant'},
		node2: {ip: "192.168.56.101", user:'vagrant', pass:'vagrant'},
		node3: {ip: "192.168.56.102", user:'vagrant', pass:'vagrant'}
		}
	end
end

require 'net/ssh'
require 'net/scp'

class Master
	include EncodeNodes
	# def initialize()
	#
	# end

	def self.check_machines
		message = Proc.new { |m| puts "===> #{m}" }
		EncodeNodes.encoders.each do |e|
			message.call "Connecting to #{e[1][:ip]}..."
			Net::SSH.start(e[1][:ip], e[1][:user], :password => e[1][:pass]) do |ssh|
				message.call "Logged in..."
				message.call "#{ssh.exec!('uname -a')}"
				message.call "Logging out..."
			end
		end
	end

	def self.transfer(ip_addr='192.168.56.100', user='vagrant', local_path='testsrc1.mpg', remote_path='/home/vagrant')
		 Net::SCP.upload!(ip_addr, user,local_path,remote_path)
	end

	def self.command(ip_addr='192.168.56.100', user='vagrant', password='vagrant', command)
		Net::SSH.start(ip_addr, user, :password => password) do |ssh|
		# ssh.exec!("docker run --rm -v pwd:/tmp/workdir -w=\"/tmp/workdir\" jrottenberg/ffmpeg -f lavfi -i testsrc=duration=10:size=1280x720:rate=30 testsrc10.mpg"
			# o = ssh.exec!(command).split(' ')
			o = ssh.exec!(command)
			puts "#{o}"
		end
	end
end

# Get duration
# Break up file based on duration(2minutes or >)
	# Generate file-src.txt
	# transfer video files to node - rm from Master
# Run encode for each node
# transfer back & rm from node
# Run Concat on master
# Finish

# require 'streamio-ffmpeg'

movie = FFMPEG::Movie.new('testsrc.mpg')
movie.duration # 120

# hh:mm:ss.000 - 00:02:00.000

# movie.transcode("movie.mp4") { |progress| system "clear"; puts "The Progress is at: #{progress.round(2)}%"; }
