require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/content_for'
require 'sinatra/partial'
require 'sinatra/flash'
require 'haml'

module Ridiquiz
  class WebApp < Sinatra::Base
    register Sinatra::Reloader if development?
    register Sinatra::Partial
    register Sinatra::Flash
    helpers Sinatra::ContentFor

    enable :logging
    enable :layout
    set :dump_errors, development?

    set :root, File.expand_path('../..', __FILE__)
    set :public_folder, Proc.new { File.join(root, 'public') }
    set :views, Proc.new { File.join(File.dirname(__FILE__), 'views') }

    set :haml, :attr_wrapper => '"'

    before do
      allowed_ip_addresses = (ENV['ALLOWED_IP_ADDRESSES'] || '').split(',')
      halt(403, 'Forbidden') unless allowed_ip_addresses.empty? or allowed_ip_addresses.include? request.ip.to_s
    end
  end
end
