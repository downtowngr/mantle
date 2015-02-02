require "spec_helper"
require_relative "../app.rb"

RSpec.describe "Mantle" do
  describe "GET location", vcr: {cassette_name: "get_location"} do
    it "returns json" do
      get "/location/foundersbrewing"

      response = JSON.parse(last_response.body)

      expect(response).to eq({"address"=>"235 Grandville Ave SW",
                             "latitude"=>42.958605,
                             "longitude"=>-85.673631,
                             "phone"=>"(616) 776-2182",
                             "fb_link"=>"https://www.facebook.com/foundersbrewing",
                             "website"=>"www.foundersbrewing.com",
                             "hours"=>nil,
                             "price_range"=>nil,
                             "tags"=>["Brewery"]})
    end
  end
end