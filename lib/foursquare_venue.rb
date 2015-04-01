require_relative "../includes/hour_helper"

class FoursquareVenue
  include HourHelper

  def initialize(id)
    @client = Foursquare2::Client.new(client_id: ENV["FOURSQUARE_ID"], client_secret: ENV["FOURSQUARE_SECRET"], api_version: "20150201")
    @venue  = @client.venue(id)
    @hours  = @client.venue_hours(id)["hours"]
  end

  # TODO:
  # Need to standardize hours, price_range, source_link, website, phone

  def attributes
    { location:
      {
        address:     @venue.location.address,
        latitude:    @venue.location.lat,
        longitude:   @venue.location.lng,
        phone:       @venue.contact.formattedPhone,
        source_link: @venue.canonicalUrl,
        website:     @venue.url,
        hours:       hours,
        price_range: attribute_type("price").summary,
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

  def tags
    tags = []

    attribute_type("serves").items.each {|i| tags << i.displayName }
    attribute_type("drinks").items.each {|i| tags << i.displayName }
    @venue.categories.each {|c| tags << c.shortName }

    tags
  end

  def reserve?
    !!@venue.reservations
  end

  def takeout?
    "Take-out" == attribute_type("diningOptions").summary
  end

  def delivery?
    "Delivery" == attribute_type("diningOptions").summary
  end

  def outdoor?
    "Outdoor Seating" == attribute_type("outdoorSeating").summary
  end

  def cash_only?
    "No Credit Cards" == attribute_type("payments").summary
  end

  def hours
    hours = {}
    days  = {1=>"Mon", 2=>"Tue", 3=>"Wed", 4=>"Thu", 5=>"Fri", 6=>"Sat", 7=>"Sun"}

    @hours.timeframes.each do |t|
      t.days.each do |k|
        hours[days[k]] = t.open.map {|segment| "#{hour12(segment["start"])}-#{hour12(segment["end"])}"}
      end
    end

    hours
  end

  def attribute_type(type)
    @venue.attributes.groups.detect do |group|
      group.type == type
    end
  end
end