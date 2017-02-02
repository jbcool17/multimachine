#!/Users/webdev/.rbenv/shims/ruby
require_relative 'lib/master_control'

m = RelationshipOfCommand::MasterControl.new

t0 = Thread.new do
  m.running_jobs
end
t1 = Thread.new do
  sleep 10
  m.running_jobs
end
t2 = Thread.new do
  sleep 20
  m.running_jobs
end
t3 = Thread.new do
  sleep 30
  m.running_jobs
end

puts "JOBS: #{m.jobs}"
t0.join
t1.join
t2.join
t3.join
puts "JOBS: #{m.jobs}"
