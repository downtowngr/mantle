require_relative "../lib/grnow_events"
require "spec_helper"

RSpec.describe GrnowEvents do
  describe "#events", vcr: {cassette_name: "grnow_events"} do
    let(:events) { GrnowEvents.new("10002").events }

    it "returns an array of events" do
      expect(events).to be_a Hash
    end

    context "all day event" do
      describe "attributes" do
        let(:event) { events[:events][0] }

        it "event_name" do
          expect(event[:event_name]).to eq("Grand Rapids Ballet 2015-16 Season Lineup")
        end

        it "start_time" do
          # Midnight EDT.
          expect(event[:start_time]).to eq(1444363200)
        end

        it "end_time" do
          expect(event[:end_time]).to be_nil
        end

        it "external_id" do
          expect(event[:external_id]).to eq("29955-1444363200-1444449599@www.grnow.com")
        end

        it "event_url" do
          expect(event[:event_url]).to eq("http://www.grnow.com/event/grand-rapids-ballet-2015-16-season-lineup/")
        end
      end
    end

    context "timed event" do
      describe "attributes" do
        let(:event) { events[:events][1] }

        it "event_name" do
          expect(event[:event_name]).to eq("Grand Rapids Symphony: Star Trek Live in Concert")
        end

        it "start_time" do
          expect(event[:start_time]).to eq(1445126400)
        end

        it "end_time" do
          expect(event[:end_time]).to eq(1445137200)
        end

        it "external_id" do
          expect(event[:external_id]).to eq("35495-1445126400-1445137200@www.grnow.com")
        end

        it "event_url" do
          expect(event[:event_url]).to eq("http://www.grnow.com/event/grand-rapids-symphony-star-trek-live-concert/")
        end
      end
    end
  end
end
