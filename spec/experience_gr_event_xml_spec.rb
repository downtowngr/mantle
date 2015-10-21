require "spec_helper"
require "nokogiri"
require "open-uri"
require_relative "../models/experience_gr_event_xml"

RSpec.describe ExperienceGrEventXml do
  before do
    @xml = Nokogiri::XML(open(File.expand_path("../fixtures/experience_gr_events.xml", __FILE__)))
  end

  describe "attributes" do
    context "without exact time" do
      let(:event_id) { @xml.xpath("//eventid").first.text }
      let(:event) { ExperienceGrEventXml.new(event_id, @xml) }

      it "#event_name" do
        expect(event.event_name).to eq("Mathias J. Alten, American Impressionist")
      end

      it "#start_date" do
        expect(event.start_date).to eq("09/15/2012")
      end

      it "#end_date" do
        expect(event.end_date).to be(nil)
      end

      it "#start_time" do
        expect(event.start_time).to be(nil)
      end

      it "#end_time" do
        expect(event.end_time).to be(nil)
      end

      it "#times" do
        expect(event.times).to eq("1:00 PM - 5:00 PM")
      end

      it "#recurrence" do
        expect(event.recurrence).to eq("Recurring weekly on Friday, Saturday")
      end

      it "#venue_id" do
        expect(event.venue_id).to be(nil)
      end

      it "#has_venue?" do
        expect(event.has_venue?).to be(false)
      end
    end

    context "with exact time" do
      let(:event_id) { @xml.xpath("//eventid").last.text }
      let(:event) { ExperienceGrEventXml.new(event_id, @xml) }

      it "#event_name" do
        expect(event.event_name).to eq("8th Annual Jay & Betty Van Andel Legacy Awards Gala")
      end

      it "#start_date" do
        expect(event.start_date).to eq("11/10/2016")
      end

      it "#end_date" do
        expect(event.end_date).to eq("11/10/2016")
      end

      it "#start_time" do
        expect(event.start_time).to eq("18:00:00")
      end

      it "#end_time" do
        expect(event.end_time).to eq("22:00:00")
      end

      it "#times" do
        expect(event.times).to be(nil)
      end

      it "#recurrence" do
        expect(event.recurrence).to be(nil)
      end

      it "#venue_id" do
        expect(event.venue_id).to be(nil)
      end

      it "#has_venue?" do
        expect(event.has_venue?).to be(false)
      end
    end
  end
end
