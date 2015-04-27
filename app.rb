require "rubygems"
require "bundler"

Bundler.require
Dotenv.load

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

module Mantle
  class Api < Sinatra::Base
    before do
      content_type :json
    end

    use Rack::Auth::Basic, "Mantle" do |username, password|
      username == ENV["MANTLE_USER"] && password == ENV["MANTLE_PASS"]
    end

    # Location
    get "/location/facebook/:id" do
      page = FacebookPage.new(params[:id])

      if page.attributes.nil?
        status [404, {error: "No data for that Facebook ID"}.to_json]
      else
        page.attributes.to_json
      end
    end

    get "/location/foursquare/:id" do
      venue = FoursquareVenue.new(params[:id])

      if venue.attributes.nil?
        status [404, {error: "No data for that Foursquare ID"}.to_json]
      else
        venue.attributes.to_json
      end
    end

    # Events
    get "/events/facebook/:id" do
      page = FacebookPage.new(params[:id])

      if page.events.nil?
        status [404, {error: "Facebook ID does not exist"}.to_json]
      else
        page.events.to_json
      end
    end

    get "/events/grnow/:id" do
      grnow = GrnowEvents.new(params[:id])

      if grnow.events.nil?
        status [404, {error: "GRNow ID does not exist"}.to_json]
      else
        grnow.events.to_json
      end
    end

    get "/events/experiencegr/:id" do
      experiencegr = ExperienceGrEvents.new(params[:id])

      if experiencegr.events.nil?
        status [404, {error: "ExperienceGR does not exist"}.to_json]
      else
        experiencegr.events.to_json
      end
    end

    # Photos
    get "/photos/instagram/user/:id" do
      media = InstagramMedia.from_user(params[:id])

      if media.nil?
        status [404, {error: "Instagram user not found"}.to_json]
      else
        media.photos.to_json
      end
    end

    get "/photos/instagram/facebook/:id" do
      media = InstagramMedia.from_facebook(params[:id])

      if media.nil?
        status [404, {error: "Facebook location in Instagram not found"}.to_json]
      else
        media.photos.to_json
      end
    end

    get "/photos/instagram/foursquare/:id" do
      media = InstagramMedia.from_foursquare(params[:id])

      if media.nil?
        status [404, {error: "Foursquare location in Instagram not found"}.to_json]
      else
        media.photos.to_json
      end
    end
  end

  class Nationbuilder < Sinatra::Base
    post "/subscription/:email" do
      nationbuilder = NationbuilderSignup.new(params[:email])

      if nationbuilder.subscribe
        status 201
      else
        status [404, {error: "Misformed or invalid email address"}.to_json]
      end
    end
  end
end
