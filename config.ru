$:.unshift File.expand_path '../src', __FILE__
require 'ridiquiz'
run Ridiquiz::WebApp
