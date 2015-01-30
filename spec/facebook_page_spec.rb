require "spec_helper"
require_relative "../lib/facebook_page"

RSpec.describe FacebookPage, vcr: {cassette_name: "facebook_page"} do
  let(:page) { FacebookPage.new("175495679140580") }

  describe "#attributes" do
    it "address" do
      expect(page.attributes[:address]).to eq("6 Jefferson Ave SE")
    end

    it "latitude and longitude" do
      expect(page.attributes[:latitude]).to eq(42.962910113333)
      expect(page.attributes[:longitude]).to eq(-85.664197562811)
    end

    it "phone" do
      expect(page.attributes[:phone]).to eq("(616) 233-3219")
    end

    it "fb_link" do
      expect(page.attributes[:fb_link]).to eq("https://www.facebook.com/pages/Bartertown-Diner/175495679140580")
    end

    it "website" do
      expect(page.attributes[:website]).to eq("www.bartertowngr.com")
    end

    it "hours" do
      expect(page.attributes[:hours]).to eq("Mon 11:00am-3:00pm Wed 11:00am-9:00pm Thu 11:00am-9:00pm 10:00pm-03:00am Fri 11:00am-9:00pm 10:00pm-03:00am Sat 09:00am-9:00pm 10:00pm-03:00am Sun 09:00am-2:00pm")
    end

    it "price_range" do
      expect(page.attributes[:price_range]).to eq("$ (0-10)")
    end

    it "cash_only" do
      expect(page.attributes[:cash_only]).to eq(false)
    end

    it "kids" do
      expect(page.attributes[:kids]).to eq(false)
    end

    it "delivery" do
      expect(page.attributes[:delivery]).to eq(false)
    end

    it "walkins" do
      expect(page.attributes[:walkins]).to eq(true)
    end

    it "reserve" do
      expect(page.attributes[:reserve]).to eq(false)
    end

    it "outdoor" do
      expect(page.attributes[:outdoor]).to eq(true)
    end

    it "takeout" do
      expect(page.attributes[:takeout]).to eq(true)
    end

    it "tags" do
      expect(page.attributes[:tags]).to eq(["Breakfast & Brunch Restaurant", "Vegetarian & Vegan Restaurant",
                               "Sandwich Shop", "Breakfast", "Coffee", "Dinner", "Lunch"])
    end
  end
end
