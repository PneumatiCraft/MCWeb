class SMPServer

  attr_reader :root
  attr_accessor :name

  def initialize(root, name = "Server")
    @root = root
    @name = name
  end

  def running?
    File.exist?(File.join(@root, "server.log.lck"))
  end
end
