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
    url            = params['url']
    multiplier     = params['multiplier'].to_i
    start_value    = params['start_value'].to_i
    tweet_template = params['tweet_template']

    range          = Range.new(start_value, start_value + multiplier, true)
    numbered_urls  = Array.new
    range.each { |i| numbered_urls << "#{url}##{i}" }

    # for each generated URL use bitly to shorten
    # { 0: { long_url: "http://foo.com#1", short_url: "http://bit.ly/whatever" } }
    # stick each shortened URL into the tweet template
    client       = BitlyClient.new.client
    results_hash = Hash.new

    numbered_urls.each_with_index do |url, i|
      results = client.shorten(url)
      tweet   = tweet_template.gsub('{link}', results.short_url)
      results_hash[i] = { long_url: results.long_url, tweet: tweet }
    end

    # build a CSV and send_file it to the user
    # results must be a CSV of
    # --- tweet with shortned link ---  ||  --- original link ---
    # this is a tweet bit.ly/foo                  foo.com#1
  end
end


class BitlyClient
  attr_reader :client

  def initialize
    Bitly.configure do |config|
      config.api_version = 3
      config.login   = ENV['username'] || Settings.username
      config.api_key = ENV['api_key']  || Settings.api_key
    end
    @client = Bitly.client
  end
end
