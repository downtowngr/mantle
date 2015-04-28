require_relative "../includes/attribute_helpers"
require "sequel"

class ExperienceGrEvents
  include AttributeHelpers

  def initialize(id)
    @table = Sequel.connect(ENV["DATABASE_URL"])[:experience_gr_events]
    @id    = id.to_i
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
    @results ||= @table.filter(venue_id: @id).all
  end
end
