require_relative "../lib/foursquare_venue"
require "spec_helper"

RSpec.describe FoursquareVenue do
  describe "#attributes", vcr: {cassette_name: "foursquare_venue"} do
    let(:page) { FoursquareVenue.new("4b12c269f964a5208b8d23e3") }
    let(:page_attributes) { page.attributes[:location] }

    it "address" do
      expect(page_attributes[:address]).to eq("235 Grandville Ave SW")
    end

    it "latitude and longitude" do
      expect(page_attributes[:latitude]).to eq(42.958428066366515)
      expect(page_attributes[:longitude]).to eq(-85.6737289899219)
    end

    it "phone" do
      expect(page_attributes[:phone]).to eq("(616) 776-1195")
    end

    it "source_link" do
      expect(page_attributes[:source_link]).to eq("https://foursquare.com/v/founders-brewing-co/4b12c269f964a5208b8d23e3")
    end

    it "website" do
      expect(page_attributes[:website]).to eq("http://www.foundersbrewing.com")
    end

    it "hours" do
      expect(page_attributes[:hours]).to eq({
        "Mon"=>["11:00am-2:00am"],
        "Tue"=>["11:00am-2:00am"],
        "Wed"=>["11:00am-2:00am"],
        "Thu"=>["11:00am-2:00am"],
        "Fri"=>["11:00am-2:00am"],
        "Sat"=>["11:00am-2:00am"],
        "Sun"=>["12:00pm-12:00am"]
      })
    end

    it "price_range" do
      expect(page_attributes[:price_range]).to eq("$$")
    end

    it "cash_only" do
      expect(page_attributes[:cash_only]).to eq(false)
    end

    it "delivery" do
      expect(page_attributes[:delivery]).to eq(false)
    end

    it "reserve" do
      expect(page_attributes[:reserve]).to eq(false)
    end

    it "outdoor" do
      expect(page_attributes[:outdoor]).to eq(true)
    end

    it "takeout" do
      expect(page_attributes[:takeout]).to eq(false)
    end

    it "tags" do
      expect(page_attributes[:tags]).to eq(["Brewery", "Sandwiches", "Brunch", "Lunch", "Dinner", "Beer", "Wine"])
    end
  end

  describe "#photos", vcr: {cassette_name: "foursquare_photos"} do
    let(:venue) { FoursquareVenue.new("4b12c269f964a5208b8d23e3") }
    let(:photos) { venue.photos[:photos] }

    it "returns an array of photos" do
      expect(photos).to be_an Array
    end

    it "returns 5 photos" do
      expect(photos.count).to eq(5)
    end

    it "returns photo_url" do
      expect(photos.first[:photo_url]).to eq("https://irs3.4sqi.net/img/general/360x360/fdBLKjSBMwxP9jM0nqvkW7iRlID0jNn3hDwsmwBXMcM.jpg")
    end

    it "returns external_id" do
      expect(photos.first[:external_id]).to eq("5033f4cae4b0a854c573a9a8")
    end

    it "returns nil external_url" do
      expect(photos.first[:external_url]).to be_nil
    end
  end
end
