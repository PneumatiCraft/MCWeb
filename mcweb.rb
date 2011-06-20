#!/usr/bin/env ruby

require 'sinatra'
require 'haml'

require 'smpserver'

configure do
  set :mcroot, "/root/minecraft"
  set :port, 25580
end

get '/' do
  @servers = SMPServer.find_servers(settings.mcroot).sort_by { |srv| srv.port }
  haml :server_list
end
