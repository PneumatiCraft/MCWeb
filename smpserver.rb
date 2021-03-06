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

  def self.mcfiles 
    [".mcweb", "server.properties", "craftbukkit-0.0.1-SNAPSHOT.jar", "Minecraft_Server.exe", "minecraft_server.jar"]
  end

  def self.find_servers(root)
    if File.exist?(root)
      SMPServer.mcfiles.each do |fname|
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

  def relative_root(real_root)
    if @root.start_with?(real_root)
      rel = @root[real_root.length..-1]
      if rel.start_with?("/")
        return rel[1..-1]
      else
        return rel
      end
    else
      return @root
    end
  end

  def minecraft_files
    files = []
    SMPServer.mcfiles.each do |fname|
      path = File.join(root, fname)
      if File.exist?(path)
        if File.symlink?(path)
          fname = File.readlink(path)
        end
        files << fname
      end
    end
    return files
  end

  def plugins
    plugins = []
    plugin_path = File.join(root, "plugins")
    if File.exist?(plugin_path) && File.directory?(plugin_path)
      Dir["#{plugin_path}/*.jar"].each do |p|
        if File.symlink?(p)
          p = File.readlink(p)
        end
        plugins << File.basename(p)
      end
    end
    return plugins
  end

end
