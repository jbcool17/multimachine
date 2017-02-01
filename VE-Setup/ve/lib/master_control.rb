require 'colorize'
require 'ruby-progressbar'
require_relative 'utilities/utilities'
require_relative 'encode_nodes'


module VE
  class MasterControl
  	attr_reader :status

  	def initialize
  		@status = ''
  	end

    def convert(name, input_file, output_file)
      VE::Utilities.transfer_to name, input_file
      VE::Utilities.run_command name, "~/bin/ffmpeg -ss 00:00:00.000 -i input/#{input_file} -t 30 output/#{output_file}"
      VE::Utilities.transfer_to_output name, "output/#{output_file}"
      VE::Utilities.run_command name, "rm ~/output/#{output_file}"
    end

  	def check_machines
  		VE::Utilities.connect_to_all 'uname -a'
  	end

  	def check_machine(name)
  		VE::Utilities.connect_to name, 'uname -a'
  	end
  end
end
