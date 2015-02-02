require "rubygems"
require "bundler"

Bundler.require
Dotenv.load

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

module Mantle
  class App < Sinatra::Application
    get "/location/:id" do
      content_type :json

      page = FacebookPage.new(params[:id])
      page.attributes.to_json
    end
  end
end
