require "spec_helper"
require_relative "../lib/facebook_page"

RSpec.describe FacebookPage do
  describe "#attributes", vcr: {cassette_name: "facebook_page"} do
    let(:page) { FacebookPage.new("175495679140580") }
    let(:page_attributes) { page.attributes[:location] }

    it "address" do
      expect(page_attributes[:address]).to eq("6 Jefferson Ave SE")
    end

    it "latitude and longitude" do
      expect(page_attributes[:latitude]).to eq(42.962910113333)
      expect(page_attributes[:longitude]).to eq(-85.664197562811)
    end

    it "phone" do
      expect(page_attributes[:phone]).to eq("(616) 233-3219")
    end

    it "source_link" do
      expect(page_attributes[:source_link]).to eq("https://www.facebook.com/pages/Bartertown-Diner/175495679140580")
    end

    it "website" do
      expect(page_attributes[:website]).to eq("www.bartertowngr.com")
    end

    it "hours" do
      expect(page_attributes[:hours]).to eq("Mon 11:00am-3:00pm Wed 11:00am-9:00pm Thu 11:00am-9:00pm 10:00pm-03:00am Fri 11:00am-9:00pm 10:00pm-03:00am Sat 09:00am-9:00pm 10:00pm-03:00am Sun 09:00am-2:00pm")
    end

    it "price_range" do
      expect(page_attributes[:price_range]).to eq("$ (0-10)")
    end

    it "cash_only" do
      expect(page_attributes[:cash_only]).to eq(false)
    end

    it "kids" do
      expect(page_attributes[:kids]).to eq(false)
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
      expect(page_attributes[:takeout]).to eq(true)
    end

    it "tags" do
      expect(page_attributes[:tags]).to eq(["Breakfast & Brunch Restaurant", "Vegetarian & Vegan Restaurant",
                               "Sandwich Shop", "Breakfast", "Coffee", "Dinner", "Lunch"])
    end
  end

  describe "#events", vcr: {cassette_name: "facebook_page_events"} do
    let(:page) { FacebookPage.new("ThePyramidScheme") }

    it "returns an array of events" do
      expect(page.events[:events]).to be_an Array
    end

    describe "an event" do
      let(:event) { page.events[:events].first }

      it "event_name" do
        expect(event[:event_name]).to eq("REVEREND HORTON HEAT + Nekromantix + Whiskey Shivers @The Pyramid Scheme 6/10")
      end

      it "start_time" do
        expect(event[:start_time]).to eq("2015-06-10T20:00:00-0400")
      end

      it "end_time" do
        expect(event[:end_time]).to be nil
      end

      it "external_id" do
        expect(event[:external_id]).to eq("1418539731769421")
      end
    end

  end
end
