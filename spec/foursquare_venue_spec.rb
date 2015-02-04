require "spec_helper"
require_relative "../lib/foursquare_venue"

RSpec.describe FoursquareVenue, vcr: {cassette_name: "foursquare_venue"} do
  let(:page) { FoursquareVenue.new("4b12c269f964a5208b8d23e3") }

  describe "#attributes" do
    it "address" do
      expect(page.attributes[:address]).to eq("235 Grandville Ave SW")
    end

    it "latitude and longitude" do
      expect(page.attributes[:latitude]).to eq(42.958428066366515)
      expect(page.attributes[:longitude]).to eq(-85.6737289899219)
    end

    it "phone" do
      expect(page.attributes[:phone]).to eq("(616) 776-1195")
    end

    it "source_link" do
      expect(page.attributes[:source_link]).to eq("https://foursquare.com/v/founders-brewing-co/4b12c269f964a5208b8d23e3")
    end

    it "website" do
      expect(page.attributes[:website]).to eq("http://www.foundersbrewing.com")
    end

    it "hours" do
      expect(page.attributes[:hours]).to eq("Mon–Sat 11:00 AM–2:00 AM Sun Noon–Midnight")
    end

    it "price_range" do
      expect(page.attributes[:price_range]).to eq("$$")
    end

    it "cash_only" do
      expect(page.attributes[:cash_only]).to eq(false)
    end

    it "delivery" do
      expect(page.attributes[:delivery]).to eq(false)
    end

    it "reserve" do
      expect(page.attributes[:reserve]).to eq(false)
    end

    it "outdoor" do
      expect(page.attributes[:outdoor]).to eq(true)
    end

    it "takeout" do
      expect(page.attributes[:takeout]).to eq(false)
    end

    it "tags" do
      expect(page.attributes[:tags]).to eq(["Brunch", "Lunch", "Dinner", "Beer", "Wine", "Brewery", "Sandwiches"])
    end
  end
end