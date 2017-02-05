require_relative 'utilities/utilities'
require_relative 'process_manager'
require_relative 'encode_nodes'
require_relative 'job'


module RelationshipOfCommand
  class MasterControl
    include RelationshipOfCommand::Utilities
    include RelationshipOfCommand::ProcessManager

  	attr_accessor :status, :jobs_rdy, :jobs_complete, :jobs_progress

  	def initialize
  		@status = ''
      @jobs_complete = []
      @jobs_progress = []
      @jobs_rdy = []
      @job_numbers = []
  	end

    def create_job(input_file, output_file, options='')
      job = RelationshipOfCommand::Job.new(set_job_number, input_file, output_file, options)

      self.message 'Master', "Job Number set to: #{job.number}"

      @jobs_rdy << job

      job
    end

    def run_jobs
      threads = []

      self.message 'Master', 'Checking Nodes Status...'
      nodes_status = self.check_for_processes 'ffmpeg'

      count = 0
      @jobs_rdy.each_with_index do |job, i|
        count = 0 if count == nodes_status.count

        # if !nodes_status.to_a[count][1]
        #   status = true
        #   while status
        #     puts "Checking"
        #     nodes_status = self.check_for_processes 'ffmpeg'
        #     nodes_status.each_with_index do |n, i|
        #       puts "test #{n}"
        #       if n.to_a[1]
        #         count += 1
        #         status = false
        #       end
        #     end
        #     sleep 5
        #   end
        # end
        name = nodes_status.to_a[count][0]
        # @jobs_progress << job
        # @jobs_rdy.delete_at(i)

        self.message name, "Starting job# #{job.number} on #{name}..."
        threads << Thread.new do
          sleep 5
          convert name, job.input_file, "#{job.number}_#{name}_#{job.output_file}"
          self.message name, "Job# #{job.number} has been completed on #{name}..."
        end

        # Change job state
        # @jobs_complete << job
        # @jobs_progress.delete_at(@jobs_progress.index(job))
        count += 1
      end

      threads.each(&:join)
      # @jobs_rdy = []
      # @jobs_progress = []
      # @jobs_complete
    end

    def convert(name, input_file, output_file, options='-t 30')
      self.transfer_to name, input_file
      self.run_command name, "~/bin/ffmpeg -v quiet -stats -i input/#{input_file} #{options} output/#{output_file}"
      self.transfer_to_output name, "output/#{output_file}"
      self.connect_to name, "rm ~/output/#{output_file}"
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
