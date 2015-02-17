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

    # Location
    get "/location/facebook/:id" do
      page = FacebookPage.new(params[:id])
      page.attributes.to_json
    end

    get "/location/foursquare/:id" do
      venue = FoursquareVenue.new(params[:id])
      venue.attributes.to_json
    end

    # Events
    get "/events/facebook/:id" do
      page = FacebookPage.new(params[:id])
      page.events.to_json
    end

    # Photos
    get "/photos/instagram/user/:id" do
      media = InstagramMedia.from_user(params[:id])
      media.photos.to_json
    end

    get "/photos/instagram/facebook/:id" do
      media = InstagramMedia.from_facebook(params[:id])
      media.photos.to_json
    end

    get "/photos/instagram/foursquare/:id" do
      media = InstagramMedia.from_foursquare(params[:id])
      media.photos.to_json
    end
  end
end
