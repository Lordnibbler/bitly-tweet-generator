require 'sinatra/base'
require 'pry'
require 'bitly'
require './bootstrap'
require './settings'

class App < Sinatra::Base
  get '/' do
    slim :index
  end

  post '/' do
    # link = http://foo.com
    # tweet template = "some shit {link here}"
    # multiplier = 3
    # start value = 0

    # take the link, and generate N number of variations, where N = multiplier,
    # taking into account the start value, S
    url         = params['url']
    multiplier  = params['multiplier'].to_i
    start_value = params['start_value'].to_i

    range = Range.new(start_value, start_value + multiplier, true)
    array = Array.new
    range.each { |i| array << "#{url}##{i}" }
    # for each generated URL use bitly to shorten
    # BitlyClient.new

    # stick each shortened URL into the tweet template

    # build a CSV and send_file it to the user
    # results must be a CSV of
    # --- tweet with shortned link ---  ||  --- original link ---
    # this is a tweet bit.ly/foo                  foo.com#1
  end
end

class BitlyClient
  def initialize
    Bitly.configure do |config|
      config.api_version = 3
      config.login   = ENV['username'] || Settings.username
      config.api_key = ENV['api_key']  || Settings.api_key
    end
  end

  def shorten

  end
end
