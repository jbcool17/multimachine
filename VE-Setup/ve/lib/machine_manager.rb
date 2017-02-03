require_relative 'encode_nodes'
require_relative 'utilities/utilities'

module RelationshipOfCommand
  class MachineManager
    include RelationshipOfCommand::Utilities

  	def start_all
      if status
        self.message 'MachineManager:', 'Starting up machines...'
        `cd ../ && vagrant up`
      else
        self.message 'MachineManager:', "Vagrant Machines are already running..."
      end
    end

    def reload_all
      `cd ../ && vagrant reload`
    end

    def stop_all
      if !status
        self.message 'MachineManager:', 'Stopping machines...'
        `cd ../ && vagrant halt`
      else
        self.message 'MachineManager:', "Vagrant Machines are already shutdown..."
      end
    end

    def status
      c = `cd ../ && vagrant status | grep running`
      if c.empty?
        self.message 'MachineManager:', 'All Machines Stopped.'
      else
        self.message 'MachineManager:', 'All Machines Running.'
      end

      c.empty?
    end

    # start one
    # stop one
    # create vagrant file
    # create encode_nodes file
    # add node
    # remove node
  end
end
