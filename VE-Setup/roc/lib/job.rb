require 'sqlite3'

module RelationshipOfCommand
  class Job
    attr_accessor :number, :input_file, :output_file, :options, :status

    def initialize(number, input_file, output_file, options='')
      @number = number
      @input_file = input_file
      @output_file = output_file
      @options = options
      @status = 'ready'
      @node = ''
      add_to_db(@number, @input_file, @output_file, @status, @options)
    end

    def read_db
      out = {}
      db = SQLite3::Database.new "db/test.db"
      db.execute( "select * from jobs" ) do |row|
        out[row[0]] = [row[1], row[2], row[3], row[4], row[5]]
      end

      out
    end

    private

    def add_to_db(job_number, input_file, output_file, status, options, node='')
      db = SQLite3::Database.new "db/test.db"

      db.execute("INSERT INTO jobs (job_number, input_file, output_file, options, status, node)
            VALUES (?, ?, ?, ?, ?, ?)", [job_number, input_file, output_file, options, status, node])

    end

  end
end
