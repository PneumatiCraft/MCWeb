#!/usr/bin/env ruby

require 'sinatra'
require 'haml'

require 'smpserver'

configure do
  set :mcroot, "/root/minecraft"
  set :port, 25579
end

get '/' do
  @servers = [ SMPServer.new(File.join(settings.mcroot, "production"), "Production" ) ]
  haml :server_list
end
