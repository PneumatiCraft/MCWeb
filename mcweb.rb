#!/usr/bin/env ruby

require 'sinatra'

configure do
  set :port, 25579
end

get '/' do
  "Hello world!"
end
