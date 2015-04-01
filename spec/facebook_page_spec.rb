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
      expect(page_attributes[:latitude]).to eq(42.962909436982)
      expect(page_attributes[:longitude]).to eq(-85.664196992376)
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
      expect(page_attributes[:hours]).to eq({
        "Wed" => ["11:00am-9:00pm"],
        "Thu" => ["11:00am-9:00pm"],
        "Fri" => ["11:00am-9:00pm"],
        "Sat" => ["9:00am-9:00pm"],
        "Sun" => ["9:00am-2:00pm"],
      })
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

    it "cover_photo" do
      expect(page_attributes[:cover_photo]).to eq("https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-xtp1/v/t1.0-9/s720x720/10801561_815107695179372_2923279076534289718_n.jpg?oh=4c5cf5702016adf9e3706de16ff78b19&oe=55AAA6DB&__gda__=1436672588_a956d0f0cd5a6cf334e98f4fee30dc91")
    end

    it "primary_photo" do
      expect(page_attributes[:primary_photo]).to eq("https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-xpf1/t31.0-8/134859_175527992470682_887927_o.jpg")
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
        expect(event[:event_name]).to eq("CLAP YOUR HANDS SAY YEAH (10th Anniversary Tour) + Teen Men @ The Pyramid Scheme 7/28")
      end

      it "start_time" do
        expect(event[:start_time]).to eq("2015-07-28T20:00:00-0400")
      end

      it "end_time" do
        expect(event[:end_time]).to be nil
      end

      it "external_id" do
        expect(event[:external_id]).to eq("838532796226882")
      end
    end

  end
end
