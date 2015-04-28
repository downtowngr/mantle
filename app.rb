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

    # Error Handling
    not_found do
      status [404, {error: "The requested resource could not be found"}.to_json]
    end

    error MissingResourceError do
      status [404, {error: "The requested #{env['sinatra.error'].message} resource could not be found"}.to_json]
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

    get "/events/grnow/:id" do
      grnow = GrnowEvents.new(params[:id])
      grnow.events.to_json
    end

    get "/events/experiencegr/:id" do
      experiencegr = ExperienceGrEvents.new(params[:id])
      experiencegr.events.to_json
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
