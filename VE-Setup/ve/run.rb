require_relative 'lib/master'
m = VE::Master.new
puts "Starting..."
m.transfer 'master'
m.command 'master', '~/bin/ffmpeg -i testsrc1.mpg testsrc1.mov'

# SPLIT JOB
# Get duration
# Break up file based on duration(2minutes or >)
	# Generate file-src.txt
	# transfer video files to node - rm from Master
# Run encode for each node
# transfer back & rm from node
# Run Concat on master
# Finish

# require 'streamio-ffmpeg'

# movie = FFMPEG::Movie.new('testsrc.mpg')
# movie.duration # 120

# hh:mm:ss.000 - 00:02:00.000

# movie.transcode("movie.mp4") { |progress| system "clear"; puts "The Progress is at: #{progress.round(2)}%"; }


# BUILD FFMPEG with Ansible for nodes
# create tests
