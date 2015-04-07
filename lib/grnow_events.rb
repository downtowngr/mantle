require "icalendar"
require "open-uri"
require_relative "../includes/attribute_helpers"

class GrnowEvents
  include AttributeHelpers

  def initialize(id)
    Dir.mkdir "tmp" unless File.exists?("tmp")
    @id = id
  end

  def events
    ical_file = load_ical_file("tmp/#{rand(36**16).to_s(36)}.ics")
    @events = Icalendar.parse(File.open(ical_file)).first.events

    array = @events.map do |e|
      {
        event_name:  e.summary,
        start_time:  start_time(e),
        end_time:    end_time(e),
        external_id: e.uid,
        url:         e.url.to_s
      }
    end

    {events: array}
  end

  def start_time(event)
    standardize_time(event.dtstart.to_s)
  end

  def end_time(event)
    end_time = standardize_time(event.dtstart.to_s)
    start_time(event) == end_time ? nil : end_time
  end

  def load_ical_file(path)
    open(path, 'wb') do |file|
      file << open("http://www.grnow.com/events/list/?tribe_venues%5B%5D=#{@id}&ical=1&tribe_display=list").read
    end

    path
  end
end