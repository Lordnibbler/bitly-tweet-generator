require 'rubygems'
require 'bundler'
require 'active_support'
require 'active_support/all'

Bundler.require :default

# Add any autoload paths here!
ActiveSupport::Dependencies.autoload_paths += [
    File.join(__dir__, 'lib'),
    File.join(__dir__, 'models')
]

# Pretty formatted HTML
Slim::Engine.set_default_options pretty: true
