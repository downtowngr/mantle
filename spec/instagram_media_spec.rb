require "spec_helper"
require_relative "../lib/foursquare_venue"

RSpec.describe InstagramMedia do
  describe "#photos" do
    context "by user id", vcr: {cassette_name: "instagram_media_user"} do
      let(:media) { InstagramMedia.from_user("downtowngrinc") }

      it "returns 5 photos" do
        expect(media.photos[:photos].count).to eq(5)
      end

      it "returns an array of photos" do
        expect(media.photos[:photos]).to be_an Array
      end

      it "returns photo_url" do
        expect(media.photos[:photos].first[:photo_url]).to eq("http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10963903_1383589831954534_537918980_n.jpg")
      end

      it "returns external_id" do
        expect(media.photos[:photos].first[:external_id]).to eq("920420860022976241_917430474")
      end

      it "returns external_url" do
        expect(media.photos[:photos].first[:external_url]).to eq("http://instagram.com/p/zF_eVFh27x/")
      end
    end

    context "by facebook id", vcr: {cassette_name: "instagram_media_facebook"} do
      let(:media) { InstagramMedia.from_facebook("uicagr") }

      it "returns 5 photos" do
        expect(media.photos[:photos].count).to eq(5)
      end

      it "returns an array of photos" do
        expect(media.photos[:photos]).to be_an Array
      end
    end

    context "by foursquare id", vcr: {cassette_name: "instagram_media_foursquare"} do
      let(:media) { InstagramMedia.from_foursquare("4b12c269f964a5208b8d23e3") }

      it "returns 5 photos" do
        expect(media.photos[:photos].count).to eq(5)
      end

      it "returns an array of photos" do
        expect(media.photos[:photos]).to be_an Array
      end
    end
  end
end
