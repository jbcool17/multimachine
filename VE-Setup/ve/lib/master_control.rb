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
      # jobs_rdy = @jobs_rdy
      self.message 'Master', 'Checking Nodes Status...'
      nodes_status = self.check_for_processes 'ffmpeg'

      @jobs_rdy.each_with_index do |job, i|
        puts "#{job} - #{i}"
          name = nodes_status.to_a[i][0]
            # @jobs_progress << job
            # @jobs_rdy.delete_at(i)

            self.message name, "Starting job# #{job.number} on #{name}..."
            threads << Thread.new do
              sleep 5
              convert name, job.input_file, "#{job.number}_#{name}_#{job.output_file}"
            end

            self.message name, "Job# #{job.number} has been completed on #{name}..."

            # Change job state
            # @jobs_complete << job
            # @jobs_progress.delete_at(@jobs_progress.index(job))
      end

      threads.each(&:join)
      # @jobs_rdy = []
      # @jobs_progress = []
      # @jobs_complete
    end

    # def run_jobs_old
    #   threads = []
    #   @jobs_rdy.each do |job|
    #     self.message 'Master', 'Checking Nodes Status...'
    #     nodes_status = self.check_for_processes 'ffmpeg'
    #
    #
    #     nodes_status.each_with_index do |node, i|
    #       name = node[0]
    #       if node[1]
    #         # Change job state
    #         @jobs_progress << job
    #         @jobs_rdy.delete(i)
    #
    #         self.message name, "Starting job# #{job.number} on #{name}..."
    #         threads << Thread.new do
    #           sleep 10
    #           convert name, job.input_file, "#{job.number}_#{name}_#{job.output_file}"
    #
    #         end
    #
    #         self.message name, "Job# #{job.number} has been completed on #{name}..."
    #
    #         # Change job state
    #         @jobs_complete << job
    #         @jobs_progress.delete(@jobs_progress.index(job))
    #         break
    #       else
    #         self.message name, "Processe(s) running on #{name}. Try again later."
    #       end
    #     end
    #   end
    #
    #   threads.each(&:join)
    #
    #   @jobs_complete
    # end

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
