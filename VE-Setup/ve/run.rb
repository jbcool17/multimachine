#master control - console control master console
require_relative 'lib/master_control'
require_relative 'lib/process_manager'
require_relative 'lib/machine_manager'

puts 'starting'
mm = RelationshipOfCommand::MachineManager.new
# mm.start_all
# mm.reload_all
# VE::MachineManager.stop_all
# puts 'stopping'
# VE::Setup.stop_machines

# VE::ProcessManager.check_all_docker_processes
# VE::Utilities.connect_to 'node1', 'ps 1868 7882 7952 9711 9781'
# pm = RelationshipOfCommand::ProcessManager.new
# pm.check_for_processes 'ffmpeg'
# VE::Utilities.connect_to_all "df -h"
# VE::Utilities.connect_to 'node1', "pgrep -f docker"

m = RelationshipOfCommand::MasterControl.new
# puts "Checking Machines..."
# m.check_machines
# m.check_machine 'node2'
# puts "Starting Convert..."
m.running_jobs
# m.convert 'node1', 'testsrc.mpg', 'testsrc.mov'



puts "Script over"
# m.transfer_to 'node1', 'testsrc.mpg'
# m.run_command 'node1', '~/bin/ffmpeg -i input/testsrc.mpg output/testsrc.mov'
# m.transfer_to_output 'node1'
# m.run_command 'node1', 'rm ~/output/testsrc.mov'


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
