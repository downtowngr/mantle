require_relative "../includes/attribute_helpers.rb"
require "spec_helper"

RSpec.describe AttributeHelpers do
  let(:helper) { (Class.new {include AttributeHelpers}).new }

  describe "#hour12" do
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

  describe "#standardize_phone" do
    it "converts phone without area code" do
      expect(helper.standardize_phone("555-1212")).to eq("(616) 555-1212")
      expect(helper.standardize_phone("5551212")).to eq("(616) 555-1212")
    end

    it "converts phone with area code" do
      expect(helper.standardize_phone("(616) 555-1212")).to eq("(616) 555-1212")
      expect(helper.standardize_phone("6165551212")).to eq("(616) 555-1212")
    end

    it "ignores nil phone" do
      expect(helper.standardize_phone(nil)).to be_nil
    end

    it "ignores phone number with letters" do
      expect(helper.standardize_phone("555 IMSTUPID")).to eq(nil)
      expect(helper.standardize_phone("BORNLIKETHIS")).to eq(nil)
    end
  end
end
