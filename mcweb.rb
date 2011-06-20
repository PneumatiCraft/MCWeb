#!/usr/bin/env ruby

require 'sinatra'
require 'haml'

require 'smpserver'

configure do
  set :mcroot, "/root/minecraft"
  set :port, 25580
end

get '/' do
  @mcroot = settings.mcroot
  @servers = SMPServer.find_servers(@mcroot).sort_by { |srv| srv.port }
  haml :server_list
end

get '/detail/*' do
  path = File.join(settings.mcroot, params[:splat][0])
  path
end
