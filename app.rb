require "rubygems"
require "bundler"

Bundler.require
Dotenv.load

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

module Mantle
  class App < Sinatra::Application
    before do
      content_type :json
    end

    get "/location/facebook/:id" do
      page = FacebookPage.new(params[:id])
      page.attributes.to_json
    end

    get "/location/foursquare/:id" do
      venue = FoursquareVenue.new(params[:id])
      venue.attributes.to_json
    end

    get "/events/facebook/:id" do
      page = FacebookPage.new(params[:id])
      page.events.to_json
    end
  end
end
