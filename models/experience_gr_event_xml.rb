class ExperienceGrEventXml
  attr_reader :xml

  def initialize(id, xml)
    @id  = id
    @xml = xml
  end

  def event_name
    get_xml_field("title")
  end

  def start_date
    get_xml_field("startdate")
  end

  def end_date
    get_xml_field("enddate")
  end

  def start_time
    get_xml_field("starttime")
  end

  def end_time
    get_xml_field("endtime")
  end

  def times
    get_xml_field("times")
  end

  def recurrence
    get_xml_field("recurrence")
  end

  def external_id
    get_xml_field("eventid")
  end

  def event_url
    get_xml_field("website")
  end

  def venue_id
    value = get_xml_field("listingid")
    value ? nil : value.to_i
  end

  def has_venue?
    !!venue_id
  end

  private

  def get_xml_field(field)
    string = xml.xpath("//events/event[eventid/text()='#{@id}']/#{field}").text
    string.empty? ? nil : string
  end
end
