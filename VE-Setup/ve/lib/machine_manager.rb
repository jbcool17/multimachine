require_relative 'encode_nodes'
require_relative 'utilities/utilities'

module VE
  module MachineManager
  	def self.start_all
      if status
        VE::Utilities.message 'Starting up machines...'
        `cd ../ && vagrant up`
      else
        VE::Utilities.message "Vagrant Machines are already running..."
      end
    end

    def self.stop_all
      if !status
        VE::Utilities.message 'Stopping machines...'
        `cd ../ && vagrant halt`
      else
        VE::Utilities.message "Vagrant Machines are already shutdown..."
      end
    end

    def self.status
      c = `cd ../ && vagrant status | grep running`
      VE::Utilities.message 'Vagrant STATUS:'
      VE::Utilities.message c
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
