module RelationshipOfCommand
  class Job
    attr_reader :number, :input_file, :output_file, :options

    def initialize(number, input_file, output_file, options='')
      @number = number
      @input_file = input_file
      @output_file = output_file
      @options = options
    end
    
  end
end
