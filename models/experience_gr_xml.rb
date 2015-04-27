class ExperienceGrXml
  attr_reader :xml

  def initialize(id, xml)
    @id  = id
    @xml = xml
  end

  def event_name
    standardize(xml.xpath("//events/event[eventid/text()='#{@id}']/title").text)
  end

  def start_date
    standardize(xml.xpath("//events/event[eventid/text()='#{@id}']/startdate").text)
  end

  def end_date
    standardize(xml.xpath("//events/event[eventid/text()='#{@id}']/enddate").text)
  end

  def external_id
    standardize(xml.xpath("//events/event[eventid/text()='#{@id}']/eventid").text)
  end

  def event_url
    standardize(xml.xpath("//events/event[eventid/text()='#{@id}']/website").text)
  end

  def venue_id
    value = xml.xpath("//events/event[eventid/text()='#{@id}']/listingid").text
    value.empty? ? nil : value.to_i
  end

  def has_venue?
    !!venue_id
  end

  private

  def standardize(string)
    string.empty? ? nil : string
  end
end
