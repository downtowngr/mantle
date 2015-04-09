require "spec_helper"
require_relative "../lib/grnow_events"

RSpec.describe GrnowEvents do
  describe "#events", vcr: {cassette_name: "grnow_events"} do
    let(:events) { GrnowEvents.new("10002").events }

    it "returns an array of events" do
      expect(events).to be_a Hash
    end

    describe "attributes" do
      let(:event) { events[:events].first }

      it "event_name" do
        expect(event[:event_name]).to eq("Joe Bonamassa at DeVos Performance Hall")
      end

      it "start_time" do
        expect(event[:start_time]).to eq(1429056000)
      end

      it "end_time" do
        expect(event[:end_time]).to be_nil
      end

      it "external_id" do
        expect(event[:external_id]).to eq("10676-1429041600-1429041600@http://www.grnow.com")
      end

      it "event_url" do
        expect(event[:event_url]).to eq("http://www.grnow.com/event/joe-bonamassa-at-devos-performance-hall/")
      end
    end
  end
end