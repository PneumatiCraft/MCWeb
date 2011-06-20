require 'pp'

class SMPServer

  attr_reader :root
  attr_accessor :name
  attr_accessor :desc

  def initialize(root, name = nil, desc = nil)
    @root = root

    @name = name
    @name = read_name if @name.nil?

    @desc = desc
    @desc = read_desc if @desc.nil?
  end

  def read_name
    read_mcweb_line(0, "Unknown")
  end

  def read_desc
    read_mcweb_line(1, "Minecraft SMP Server")
  end

  def read_mcweb_line(idx, default = nil)
    mcw_path = File.join(@root, ".mcweb")

    if File.exist?(mcw_path)
      contents = IO.read(mcw_path).split("\n")
      if idx < contents.length
        return contents[idx]
      end
    end

    return default
  end

  def running?
    File.exist?(File.join(@root, "server.log.lck"))
  end

  def port
    prop_path = File.join(@root, "server.properties")
    if File.exist?(prop_path)

      File.open(prop_path) do |f|
        while line = f.gets

          if line.start_with?("server-port=")
            return line[12..-1].to_i
          end

        end
      end

    else
      return 25565
    end
  end

  def self.find_servers(root)
    if File.exist?(root)
      [".mcweb", "server.properties", "craftbukkit-0.0.1-SNAPSHOT.jar", "Minecraft_Server.exe", "minecraft_server.jar"].each do |fname|
        if File.exist?(File.join(root, fname))
          puts "Found server at #{root}"
          return [ SMPServer.new(root) ]
        end
      end

      accum = []
      Dir[File.join(root, '*/')].each do |subdir|
        accum = accum + SMPServer.find_servers(subdir)
      end
      puts "Recursed; found servers #{accum}"
      return accum
    else
      puts "#{root} doesn't exist"
      return []
    end
  end

end
