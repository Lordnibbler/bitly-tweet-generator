require 'sinatra/base'
require './bootstrap'
require 'pry'

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
    # http://foo.com#S
    # http://foo.com#S+1
    # http://foo.com#..n

    # for each generated URL use bitly to shorten

    # stick each shortened URL into the tweet template

    # build a CSV and send_file it to the user
    # results must be a CSV of
    # --- tweet with shortned link ---  ||  --- original link ---
    # this is a tweet bit.ly/foo                  foo.com#1
  end
end
