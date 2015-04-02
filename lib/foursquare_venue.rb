require_relative "../includes/attribute_helpers"

class FoursquareVenue
  include AttributeHelpers

  def initialize(id)
    @client = Foursquare2::Client.new(client_id: ENV["FOURSQUARE_ID"], client_secret: ENV["FOURSQUARE_SECRET"], api_version: "20150201")
    @venue  = @client.venue(id)
    @hours  = @client.venue_hours(id)["hours"]
  end

  # TODO:
  # Need to standardize source_link, website, phone

  def attributes
    { location:
      {
        address:     @venue.location.address,
        latitude:    @venue.location.lat,
        longitude:   @venue.location.lng,
        phone:       phone,
        source_link: @venue.canonicalUrl,
        website:     website,
        hours:       hours,
        price_range: attribute_summary("price"),
        cash_only:   cash_only?,
        outdoor:     outdoor?,
        delivery:    delivery?,
        takeout:     takeout?,
        reserve:     reserve?,
        kids:        nil,
        tags:        tags
      }
    }
  end

  private

  def phone
    standardize_phone(@venue.contact.formattedPhone)
  end

  def website
    standardize_url(@venue.url)
  end

  def tags
    return nil if @venue.categories.nil?

    tags = []
    @venue.categories.each {|c| tags << c.shortName }

    ["serves", "drinks"].each do |group|
      attributes = attribute_type(group)
      attributes.items.each {|i| tags << i.displayName } unless attributes.nil?
    end

    tags.uniq
  end

  def reserve?
    !!@venue.reservations
  end

  def takeout?
    "Take-out" == attribute_summary("diningOptions")
  end

  def delivery?
    "Delivery" == attribute_summary("diningOptions")
  end

  def outdoor?
    "Outdoor Seating" == attribute_summary("outdoorSeating")
  end

  def cash_only?
    "No Credit Cards" == attribute_summary("payments")
  end

  def hours
    return nil if @hours.timeframes.nil?

    hours = {}
    days  = {1=>"Mon", 2=>"Tue", 3=>"Wed", 4=>"Thu", 5=>"Fri", 6=>"Sat", 7=>"Sun"}

    @hours.timeframes.each do |t|
      t.days.each do |k|
        hours[days[k]] = t.open.map {|segment| "#{hour12(segment["start"])}-#{hour12(segment["end"])}"}
      end
    end

    hours
  end

  def attribute_summary(group)
    attributes = attribute_type(group)
    attributes.summary if attributes
  end

  def attribute_type(type)
    @venue.attributes.groups.detect do |group|
      group.type == type
    end
  end
end