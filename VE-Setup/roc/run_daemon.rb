require_relative 'lib/master_control'
require_relative 'lib/process_manager'
require_relative 'lib/machine_manager'

puts 'starting'
mc = RelationshipOfCommand::MasterControl.new


loop do
  puts "Finding jobs..."
  mc.run_jobs
  puts "Break..."
  sleep 10
end
