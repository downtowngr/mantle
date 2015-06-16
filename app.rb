require "rubygems"
require "bundler"

Bundler.require

configure :development, :test do
  require "dotenv"
  Dotenv.load
end

require_relative "db/load_db"

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/models/*.rb'].each { |file| require file }

module Mantle
  class Api < Sinatra::Base
    before do
      content_type :json
    end

    use Rack::Auth::Basic, "Mantle" do |username, password|
      username == ENV["MANTLE_API_USER"] && password == ENV["MANTLE_API_PASS"]
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
    get "/photos/instagram/:id" do
      media = InstagramMedia.new(params[:id])
      media.photos.to_json
    end

    get "/photos/foursquare/:id" do
      venue = FoursquareVenue.new(params[:id])
      venue.photos.to_json
    end
  end

  class Admin < Sinatra::Base
    use Rack::Auth::Basic, "Admin" do |username, password|
      username == ENV["MANTLE_ADMIN_USER"] && password == ENV["MANTLE_ADMIN_PASS"]
    end

    get "/" do
      @oauth = FacebookOauth.new
      erb :admin
    end

    get "/oauth" do
      @oauth = FacebookOauth.new
      @oauth.fetch_access_token_from_code(params[:code])

      redirect "/admin"
    end
  end
end
