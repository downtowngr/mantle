require "spec_helper"
require_relative "../app.rb"

RSpec.describe "Mantle" do
  describe "GET /location" do
    describe "from Facebook", vcr: {cassette_name: "location_facebook"} do
      it "returns a location json object" do
        get "/location/facebook/foundersbrewing"

        response = JSON.parse(last_response.body)

        expect(response).to eq({
          "address" => "235 Grandville Ave SW",
          "cash_only" => nil,
          "delivery" => nil,
          "hours" => nil,
          "kids" => nil,
          "latitude" => 42.958605,
          "longitude" => -85.673631,
          "outdoor" => nil,
          "phone" => "(616) 776-2182",
          "price_range" => nil,
          "reserve" => nil,
          "source_link" => "https://www.facebook.com/foundersbrewing",
          "tags" => ["Brewery"],
          "takeout" => nil,
          "website" => "www.foundersbrewing.com",
        })
      end
    end

    describe "from Foursquare", vcr: {cassette_name: "location_foursquare"}  do
      it "returns a location json object" do
        get "/location/foursquare/4b12c269f964a5208b8d23e3"

        response = JSON.parse(last_response.body)

        expect(response).to eq({
          "address"=>"235 Grandville Ave SW",
          "cash_only" => false,
          "delivery" => false,
          "hours" => "Mon–Sat 11:00 AM–2:00 AM Sun Noon–Midnight",
          "kids" => nil,
          "latitude" => 42.958428066366515,
          "longitude" => -85.6737289899219,
          "outdoor" => true,
          "phone" => "(616) 776-1195",
          "price_range" => "$$",
          "reserve" => false,
          "source_link" => "https://foursquare.com/v/founders-brewing-co/4b12c269f964a5208b8d23e3",
          "tags" => ["Brunch", "Lunch", "Dinner", "Beer", "Wine", "Brewery", "Sandwiches"],
          "takeout" => false,
          "website" => "http://www.foundersbrewing.com",
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