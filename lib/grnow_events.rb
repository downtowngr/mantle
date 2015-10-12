require "icalendar"
require "open-uri"

class GrnowEvents
  include AttributeHelpers

  def initialize(id)
    Dir.mkdir "tmp" unless File.exists?("tmp")
    @id = id
  end

  def events
    @events ||= ical_events

    array = @events.map do |e|
      {
        event_name:  e.summary,
        start_time:  start_time(e),
        end_time:    end_time(e),
        external_id: e.uid,
        event_url:   e.url.to_s
      }
    end

    {events: array}
  rescue OpenURI::HTTPError
    {events: []}
  end

  def start_time(event)
    if event.dtstart.class == Icalendar::Values::Date
      date = event.dtstart
      Time.new(date.year, date.month, date.day, 0, 0, 0, Time.zone_offset('EDT')).to_i
    else event.dtstart.class == Icalendar::Values::DateTime
      event.dtstart.to_time.to_i
    end
  end

  def end_time(event)
    return nil if event.dtstart.class == Icalendar::Values::Date
    return nil if event.dtstart.to_s == event.dtend.to_s

    event.dtend.to_time.to_i
  end

  def ical_events
    path = "tmp/#{rand(36**16).to_s(36)}.ics"

    open(path, 'wb') do |file|
      file << open("http://www.grnow.com/events/list/?tribe_venues%5B%5D=#{@id}&ical=1&tribe_display=list").read
    end

    Icalendar.parse(File.open(path)).first.events
  end
end
