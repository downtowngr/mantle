require_relative "../models/experience_gr_event_xml"
require "open-uri"
require "nokogiri"
require "sequel"

class LoadExperienceGr
  def initialize
    @db = Sequel.connect(ENV["DATABASE_URL"])
    @db.extension :pg_array
  end

  def prepare_db
    @db.drop_table?  :experience_gr_events
    @db.create_table :experience_gr_events do
      primary_key :id

      column :event_name, :text
      column :start_date, :date
      column :end_date, :date
      column :start_time, :text
      column :end_time, :text
      column :event_dates, "text[]"
      column :times, :text
      column :recurrence, :text
      column :external_id, :text
      column :event_url, :text
      column :venue_id, :integer

      index :venue_id
    end

    @db.drop_table?  :experience_gr_listings
    @db.create_table :experience_gr_listings do
      primary_key :id

      column :venue_id, :integer
      column :account_id, :integer

      index :account_id
    end
  end

  def perform
    prepare_db

    event_ids.each do |id|
      model = ExperienceGrEventXml.new(id, events_xml)

      @db[:experience_gr_events].insert(
        event_name:  model.event_name,
        start_date:  model.start_date,
        end_date:    model.end_date,
        start_time:  model.start_time,
        end_time:    model.end_time,
        event_dates: Sequel.pg_array(model.event_dates),
        times:       model.times,
        recurrence:  model.recurrence,
        external_id: model.external_id,
        event_url:   model.event_url,
        venue_id:    model.venue_id
      ) if model.has_venue?
    end

    listing_ids.each do |id|
      account_id = listings_xml.xpath("//listings/listing[listingid/text()='#{id}']/accountid").text.to_i
      next if account_id == 0

      @db[:experience_gr_listings].insert(
        venue_id: id,
        account_id: account_id
      )
    end
  end

  def events_xml
    @events_xml ||= Nokogiri::XML(open(ENV["EXPERIENCEGR_EVENTS_URI"], read_timeout: 120))
  end

  def listings_xml
    @listings_xml ||= Nokogiri::XML(open(ENV["EXPERIENCEGR_LISTINGS_URI"], read_timeout: 120))
  end

  def event_ids
    @event_ids ||= events_xml.xpath("//eventid").map &:text
  end

  def listing_ids
    @listing_ids ||= listings_xml.xpath("//listingid").map &:text
  end
end
