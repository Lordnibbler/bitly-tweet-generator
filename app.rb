require 'sinatra/base'
require 'bitly'
require './bootstrap'
require './settings'

class App < Sinatra::Base

  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    username == (ENV['username'] || Settings.username) and
    password == (ENV['password'] || Settings.password)
  end

  get '/' do
    slim :index
  end

  post '/' do
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
    csv_string = CSV.generate do |csv|
      results_hash.each_key do |k|
        csv << [results_hash[k][:tweet], results_hash[k][:long_url]]
      end
    end
    csv_string = "tweet,link\n" + csv_string

    content_type 'application/csv'
    attachment   'tweets.csv'
    csv_string
  end
end


class BitlyClient
  attr_reader :client

  def initialize
    Bitly.configure do |config|
      config.api_version = 3
      config.login   = ENV['bitly_username'] || Settings.username
      config.api_key = ENV['bitly_api_key']  || Settings.api_key
    end
    @client = Bitly.client
  end
end
