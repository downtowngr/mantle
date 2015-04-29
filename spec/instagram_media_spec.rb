require "spec_helper"
require_relative "../lib/foursquare_venue"

RSpec.describe InstagramMedia do
  describe "#photos", vcr: {cassette_name: "instagram_media"} do
    let(:media) { InstagramMedia.new("downtowngrinc") }

    it "returns 5 photos" do
      expect(media.photos[:photos].count).to eq(5)
    end

    it "returns an array of photos" do
      expect(media.photos[:photos]).to be_an Array
    end

    it "returns photo_url" do
      expect(media.photos[:photos].first[:photo_url]).to eq("https://scontent.cdninstagram.com/hphotos-xfa1/t51.2885-15/e15/11189642_761760627277463_867796486_n.jpg")
    end

    it "returns external_id" do
      expect(media.photos[:photos].first[:external_id]).to eq("969525272003439820_917430474")
    end

    it "returns external_url" do
      expect(media.photos[:photos].first[:external_url]).to eq("https://instagram.com/p/10chkeh2zM/")
    end
  end
end
