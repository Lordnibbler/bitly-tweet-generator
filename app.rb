require 'sinatra/base'
require './bootstrap'
require 'pry'

class App < Sinatra::Base
  get '/' do
    slim :index
  end

  post '/' do
  end
end
