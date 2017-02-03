require_relative 'utilities/utilities'
require_relative 'process_manager'
require_relative 'encode_nodes'


module RelationshipOfCommand
  class MasterControl
    include RelationshipOfCommand::Utilities
    include RelationshipOfCommand::ProcessManager

  	attr_reader :status, :jobs

  	def initialize
  		@status = ''
      @jobs = []
  	end

    def running_jobs
      status = self.check_for_processes 'ffmpeg'

      job_number = set_job_number
      self.message 'Master', "Job Number set to: #{job_number}"

      status.each do |node|
        name = node[0]
        if node[1]
          self.message name, "Starting job# #{job_number} on #{name}..."
          convert name, 'testsrc.mpg', "#{job_number}_#{name}_testsrc.mov"
          self.message name, "Job# #{job_number} has been completed on #{name}..."
          break
        else
          self.message name, "Processe(s) running. Try again later."
        end
      end

    end

    def convert(name, input_file, output_file)
      self.transfer_to name, input_file
      self.connect_to name, "~/bin/ffmpeg -ss 00:00:00.000 -i input/#{input_file} -t 60 output/#{output_file}"
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
      job_number = rand(1..10)

      while !@jobs.include?(job_number)
        if !@jobs.include?(job_number)
          @jobs << job_number
        else
          job_number = rand(1..10)
        end
      end

      job_number
    end
  end
end
