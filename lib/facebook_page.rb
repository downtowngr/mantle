class FacebookPage
  def initialize(id)
    @graph = Koala::Facebook::API.new(ENV["FB_TOKEN"])
    @page  = @graph.get_object(id)
  end

  def attributes
    {
      address:     @page["location"]["street"],
      latitude:    @page["location"]["latitude"],
      longitude:   @page["location"]["longitude"],
      phone:       @page["phone"],
      source_link: @page["link"],
      website:     @page["website"],
      hours:       hours,
      price_range: @page["price_range"],
      cash_only:   cash_only?,
      outdoor:     outdoor?,
      delivery:    delivery?,
      takeout:     takeout?,
      reserve:     reserve?,
      kids:        kids?,
      tags:        tags
    }
  end

  private

  def cash_only?
    @page["payment_options"] ? @page["payment_options"]["cash_only"] == 1 : nil
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

    string = ""

    days = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]

    days.each_with_index do |day, index|
      unless nested[day].empty?
        string << day.capitalize + " "

        nested[day].each do |_, hour|
          string << hour12(hour["open"]) + "-" + hour12(hour["close"]) + " "
        end
      end
    end

    string.strip
  end

  def hour12(time)
    digits = time.split(":")

    if digits[0].to_i > 12
      "#{digits[0].to_i - 12}:#{digits[1]}pm"
    else
      "#{time}am"
    end
  end

  def tags
    @page["category_list"].map {|c| c["name"]} + restaurant_specialties
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
