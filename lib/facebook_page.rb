require_relative "../includes/attribute_helpers"
require_relative "../models/mantle_setting"

class FacebookPage
  include AttributeHelpers

  def initialize(id)
    Koala.config.api_version = "v2.5"
    @graph   = Koala::Facebook::API.new(MantleSetting.fb_token)
    @id      = id
  end

  def attributes
    #@page   ||= @graph.get_object(@id)
    # id,name,location,phone,link,website,hours,price_range,payment_options,restaurant_services,category_list,restaurant_specialties,cover,photos.limit(1){images}
    @page   ||= @graph.get_object(@id, fields: [:id, :name, :location, :phone, :link, :website, :hours, :price_range, :payment_options, :restaurant_services, :category_list, :restaurant_specialties, :cover] )
    @photos ||= @graph.get_connections(@id, "photos", { fields: ['images'] } )

    {
      location: {
        address:     @page["location"] && @page["location"]["street"],
        latitude:    @page["location"] && @page["location"]["latitude"],
        longitude:   @page["location"] && @page["location"]["longitude"],
        phone:       phone,
        source_link: @page["link"],
        website:     website,
        hours:       hours,
        price_range: @page["price_range"],
        cash_only:   cash_only?,
        outdoor:     outdoor?,
        delivery:    delivery?,
        takeout:     takeout?,
        reserve:     reserve?,
        kids:        kids?,
        tags:        tags,
        cover_photo: @page["cover"] && @page["cover"]["source"],
        primary_photo: @photos && @photos.first && @photos.first["images"].first["source"]
      }
    }
  rescue Koala::Facebook::ClientError
    raise MissingResourceError, "Facebook location"
  end

  def events
    @events ||= @graph.get_connections(@id, "events", { "limit" => "75", "since" => "now"})

    array = @events.map do |e|
      {
        event_name:  e["name"],
        start_time:  standardize_time(e["start_time"]),
        end_time:    standardize_time(e["end_time"]),
        external_id: e["id"]
      }
    end

    {events: array}
  rescue Koala::Facebook::ClientError
    raise MissingResourceError, "Facebook events"
  end

  private

  def standardize_time(time)
    return nil unless time

    if time.include?("T")
      Time.parse(time).to_i
    else
      ymd = time.split("-")
      Time.new(ymd[0], ymd[1], ymd[2], nil, nil, nil).to_i
    end
  end

  def phone
    standardize_phone(@page["phone"])
  end

  def website
    standardize_url(@page["website"])
  end

  def cash_only?
    @page["payment_options"] ?
      @page["payment_options"]["cash_only"] == 1 && @page["payment_options"].select {|k,v| v == 1}.count == 1 : nil
  end

  def outdoor?
    @page["restaurant_services"] ? @page["restaurant_services"]["outdoor"] == 1 : nil
  end

  def delivery?
    @page["restaurant_services"] ? @page["restaurant_services"]["delivery"] == 1 : nil
  end

  def takeout?
    @page["restaurant_services"] ? @page["restaurant_services"]["takeout"] == 1 : nil
  end

  def reserve?
    @page["restaurant_services"] ? @page["restaurant_services"]["reserve"] == 1 : nil
  end

  def kids?
    @page["restaurant_services"] ? @page["restaurant_services"]["kids"] == 1 : nil
  end

  def hours
    return nil if @page["hours"].nil?

    nested = Hash.new {|h,k| h[k] = Hash.new(&h.default_proc) }

    @page["hours"].each do |k, hour|
      date = k.split("_")
      nested[date[0]][date[1].to_i][date[2]] = hour
    end

    hours = {}
    days  = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]

    days.each_with_index do |day, index|
      unless nested[day].empty?
        hours[day.capitalize] = []

        nested[day].each do |_, hour|
          hours[day.capitalize] << hour12(hour["open"]) + "-" + hour12(hour["close"])
        end
      end
    end

    hours
  end

  def tags
    category_list + restaurant_specialties
  end

  def category_list
    @page["category_list"] ? @page["category_list"].map {|c| c["name"]} : []
  end

  def restaurant_specialties
    if @page["restaurant_specialties"]
      array = @page["restaurant_specialties"].map {|s, b| s.capitalize if b == 1}
      array.compact
    else
      []
    end
  end
end
