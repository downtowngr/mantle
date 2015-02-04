require "spec_helper"
require_relative "../app.rb"

RSpec.describe "Mantle" do
  describe "GET /location" do
    describe "from Facebook", vcr: {cassette_name: "location_facebook"} do
      it "returns a location json object" do
        get "/location/facebook/foundersbrewing"

        response = JSON.parse(last_response.body)

        expect(response).to eq({
          "address"=>"235 Grandville Ave SW",
          "latitude"=>42.958605,
          "longitude"=>-85.673631,
          "phone"=>"(616) 776-2182",
          "source_link"=>"https://www.facebook.com/foundersbrewing",
          "website"=>"www.foundersbrewing.com",
          "hours"=>nil,
          "price_range"=>nil,
          "tags"=>["Brewery"]
        })
      end
    end

    describe "from Foursquare", vcr: {cassette_name: "location_foursquare"}  do
      it "returns a location json object" do
        get "/location/foursquare/founderbrewing"

        response = JSON.parse(last_response.body)

        expect(response).to eq({
          "address"=>"235 Grandville Ave SW",
          "latitude"=>42.958605,
          "longitude"=>-85.673631,
          "phone"=>"(616) 776-2182",
          "source_link"=>"https://www.facebook.com/foundersbrewing",
          "website"=>"www.foundersbrewing.com",
          "hours"=>nil,
          "price_range"=>nil,
          "tags"=>["Brewery"]
        })
      end
    end

    describe "from Google Places" do
    end
  end

  describe "GET /events" do
    describe "from Facebook" do
    end

    describe "from ExperienceGR" do
    end

    describe "from GRNow" do
    end
  end
end