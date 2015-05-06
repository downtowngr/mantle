require_relative "../includes/attribute_helpers.rb"
require "spec_helper"

RSpec.describe AttributeHelpers do
  describe "#hour12" do
    let(:helper) { (Class.new {include AttributeHelpers}).new }

    context "in the am" do
      it "converts string with semicolon" do
        expect(helper.hour12("10:00")).to eq("10:00am")
      end

      it "converts string without semicolon" do
        expect(helper.hour12("0900")).to eq("9:00am")
      end

      it "converts midnight properly" do
        expect(helper.hour12("0000")).to eq("12:00am")
        expect(helper.hour12("0:00")).to eq("12:00am")

        expect(helper.hour12("0030")).to eq("12:30am")
        expect(helper.hour12("0:30")).to eq("12:30am")
      end
    end

    context "in the pm" do
      it "converts string with semicolon" do
        expect(helper.hour12("14:00")).to eq("2:00pm")
      end

      it "converts string without semicolon" do
        expect(helper.hour12("1500")).to eq("3:00pm")
      end

      it "converts noon properly" do
        expect(helper.hour12("1200")).to eq("12:00pm")
        expect(helper.hour12("12:00")).to eq("12:00pm")

        expect(helper.hour12("1230")).to eq("12:30pm")
        expect(helper.hour12("12:30")).to eq("12:30pm")
      end
    end
  end
end
