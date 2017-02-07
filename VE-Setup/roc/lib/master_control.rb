require_relative 'utilities/utilities'
require_relative 'process_manager'
require_relative 'encode_nodes'
require_relative 'job'


module RelationshipOfCommand
  class MasterControl
    include RelationshipOfCommand::Utilities
    include RelationshipOfCommand::ProcessManager

  	attr_accessor :status
    attr_reader :job_numbers

  	def initialize
  		@status = ''
      @job_numbers = []
      Struct.new('Job', :number, :input_file, :output_file, :options, :status, :node)
  	end

    def clear_jobs
      self.message 'Master', 'Clearing jobs...'
      self.delete_all_rows
      self.message 'Master', 'Complete'
    end

    def create_job(input_file, output_file, options='')
      job = RelationshipOfCommand::Job.new(set_job_number, input_file, output_file, options)
      self.message 'Master', "Job Number set to: #{job.number}"

      job
    end

    def get_jobs
      self.message 'Master', 'Listing Jobs...'
      self.get_all_jobs.each do |j|
        puts "JOB: #{j}"
      end
    end

    def run_jobs
      threads = []

      self.message 'Master', 'Checking Nodes Status...'
      nodes_status = self.check_for_processes 'ffmpeg'

      count = 0
      get_jobs_in_ready.each do |job_number, v|
        job = Struct::Job.new(job_number, v[0], v[1], v[2], v[3], v[4])
        count = 0 if count == nodes_status.count
        name = nodes_status.to_a[count][0]

        self.message name, "Starting job# #{job.number} on #{name}..."
        threads << Thread.new do
          sleep 5
          convert name, job.input_file, "#{job.number}_#{name}_#{job.output_file}", job_number
          self.message name, "Job# #{job.number} has been completed on #{name}..."
        end

        count += 1
      end

      threads.each(&:join)

    end

    def convert(name, input_file, output_file, options='-t 30', job_number)
      self.transfer_to name, input_file
      self.change_status(job_number, 'running', name)
      self.run_command name, "~/bin/ffmpeg -v quiet -stats -i input/#{input_file} #{options} output/#{output_file}"
      self.transfer_to_output name, "output/#{output_file}"
      self.change_status(job_number, 'completed', name)
      # self.connect_to name, "rm ~/output/#{output_file}"
    end

  	def check_machines
  		self.connect_to_all 'uname -a'
  	end

  	def check_machine(name)
  		self.connect_to name, 'uname -a'
  	end

    private

    def set_job_number
      job_number = rand(1..100)

      while !@job_numbers.include?(job_number)
        if !@job_numbers.include?(job_number)
          @job_numbers << job_number
        else
          job_number = rand(1..100)
        end
      end

      job_number
    end
  end
end
