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
  end

  describe "GET /events" do
    describe "from Facebook", vcr: {cassette_name: "events_facebook"} do
      it "returns an array of events" do
        get "/events/facebook/uicagr"

        response = JSON.parse(last_response.body)

        expect(response).to eq({
          "events" => [
            {
              "name"=>"Bring Your Own Beamer Grand Rapids 02",
              "start_time"=>"2015-03-06T18:00:00-0500",
              "end_time"=>"2015-03-06T23:00:00-0500",
              "external_id"=>"1547366848875583"
            },
            {
              "name"=>"Open Projector Night No. 10",
              "start_time"=>"2015-02-18T20:00:00-0500",
              "end_time"=>nil,
              "external_id"=>"559480167521476"
            },
            {
              "name"=>"Portraits by James LaCroix: Opening Reception",
              "start_time"=>"2015-02-13T18:00:00-0500",
              "end_time"=>"2015-02-13T20:00:00-0500",
              "external_id"=>"900554633308138"
            },
            {
              "name"=>"Looking Forward Collector's Talk and Silent Auction",
              "start_time"=>"2015-02-06T19:00:00-0500",
              "end_time"=>"2015-02-06T20:00:00-0500","external_id"=>"1408844586079669"
            }
          ]
        })
      end
    end

    describe "from Foursquare" do

    end

    describe "from GRNow" do
    end
  end
end