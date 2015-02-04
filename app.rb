require "rubygems"
require "bundler"

Bundler.require
Dotenv.load

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

module Mantle
  class App < Sinatra::Application
    get "/location/facebook/:id" do
      content_type :json

      page = FacebookPage.new(params[:id])
      page.attributes.to_json
    end
  end
end
