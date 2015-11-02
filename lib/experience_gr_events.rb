require_relative "../includes/attribute_helpers"
require "sequel"

class ExperienceGrEvents
  include AttributeHelpers

  def initialize(id)
    @id = id.to_i
  end

  def events
    array = []
    results.each do |e|
      e[:event_dates].each do |date|
        array << {
          event_name:  e[:event_name],
          start_time:  start_time(date, e[:start_time]),
          end_time:    end_time(date, e[:end_time]),
          external_id: e[:external_id],
          event_url:   e[:event_url]
        }
      end
    end

    {events: array}
  end

  private

  def start_time(date, time)
    if time.nil? || time.empty?
      Time.strptime("#{date} 00:00:00 EDT", "%m/%d/%Y %T %Z").to_i
    else
      Time.strptime("#{date} #{time} EDT", "%m/%d/%Y %T %Z").to_i
    end
  end

  def end_time(date, time)
    puts time
    if time.nil? || time.empty?
      nil
    else
      Time.strptime("#{date} #{time} EDT", "%m/%d/%Y %T %Z").to_i
    end
  end

  def results
    listing_ids = [@id]

    # Find Account ID, if available, for requested Listing ID
    accounts = DB[:experience_gr_listings].filter(venue_id: @id)
    unless accounts.empty?
      account_id = accounts.first[:account_id]
    end

    DB[:experience_gr_listings].filter(account_id: account_id).all.each { |a| listing_ids << a[:venue_id] }
    listing_ids.uniq!

    DB[:experience_gr_events].filter(venue_id: listing_ids).all
  end
end
