require_relative "../includes/attribute_helpers"
require "sequel"

class ExperienceGrEvents
  include AttributeHelpers

  def initialize(id)
    @db = Sequel.connect(ENV["DATABASE_URL"])
    @id = id.to_i
  end

  def events
    array = results.map do |e|
      {
        event_name:  e[:event_name],
        start_time:  start_time(e),
        end_time:    end_time(e),
        external_id: e[:external_id],
        event_url:   e[:event_url]
      }
    end

    {events: array}
  end

  private

  def start_time(event)
    standardize_datetime(event[:start_date].to_datetime)
  end

  def end_time(event)
    if event[:start_date].to_s == event[:end_date].to_s
      nil
    elsif event[:end_date].nil?
      nil
    else
      standardize_datetime(event[:end_date].to_datetime)
    end
  end

  def results
    listing_ids = [@id]

    # Find Account ID, if available, for requested Listing ID
    accounts = @db[:experience_gr_listings].filter(venue_id: @id)
    unless accounts.empty?
      account_id = accounts.first[:account_id]
    end

    @db[:experience_gr_listings].filter(account_id: account_id).all.each { |a| listing_ids << a[:venue_id] }
    listing_ids.uniq!

    @db[:experience_gr_events].filter(venue_id: listing_ids).all
  end
end
