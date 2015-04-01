require "spec_helper"
require_relative "../lib/foursquare_venue"

RSpec.describe FoursquareVenue, vcr: {cassette_name: "foursquare_venue"} do
  let(:page) { FoursquareVenue.new("4b12c269f964a5208b8d23e3") }
  let(:page_attributes) { page.attributes[:location] }

  describe "#attributes" do
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
        "Sun"=>["12:00pm-0:00am"]
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
      expect(page_attributes[:tags]).to eq(["Brunch", "Lunch", "Dinner", "Beer", "Wine", "Brewery", "Sandwiches"])
    end
  end
end