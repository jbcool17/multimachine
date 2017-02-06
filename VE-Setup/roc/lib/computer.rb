
module RelationshipOfCommand
  class Computer
    attr_accessor :ip, :user, :pass

    def initialize(ip, user, pass)
      @ip, @user, @pass = ip, user, pass
    end
  end
end

module RelationshipOfCommand
  class Master < Computer
    attr_reader :type

    def initialize(ip, user, pass)
      super(ip, user, pass)
      @type = 'master'
    end
  end
end

module RelationshipOfCommand
  class Node < Computer
    attr_reader :type

    def initialize(ip, user, pass)
      super(ip, user, pass)
      @type = 'node'
    end
  end
end
