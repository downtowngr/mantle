require "spec_helper"
require_relative "../tasks/generate_bike_parking"

RSpec.describe GenerateBikeParking do
  describe "#perform", vcr: {cassette_name: "bike_parking"} do
    xit "returns stuff" do
      expect(GenerateBikeParking.new.perform).to be true
    end
  end
end