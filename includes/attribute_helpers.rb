module AttributeHelpers
  require "domainatrix"
  require "phone_wrangler"

  def hour12(time)
    # Converts 24-hour string into 12-hour string.

    time.gsub!(/^\+/, "")

    if time.include?(":")
      digits = time.split(":")
    else
      digits = [time[0..1], time[2..3]]
    end

    if digits[0].to_i > 12
      "#{digits[0].to_i - 12}:#{digits[1]}pm"
    elsif digits[0].to_i == 12
      "#{digits[0]}:#{digits[1]}pm"
    elsif digits[0].to_i == 0
      "12:#{digits[1]}am"
    else
      "#{digits[0].gsub(/^0/, "")}:#{digits[1]}am"
    end
  end

  def standardize_url(url)
    return nil if url.nil?
    Domainatrix.parse(url.split(" ").first).url
  rescue
    nil
  end

  def standardize_phone(phone)
    return nil if phone.nil?
    return nil if /[[:alpha:]]/.match(phone)

    number = PhoneWrangler::PhoneNumber.new(phone)
    number.area_code = "616" if number.area_code.nil?
    number.to_s
  end

  def standardize_datetime(dt)
    # Datetime to EDT unix timestamp
    
    if dt.zone == "+00:00"
      Time.new(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second, Time.zone_offset('EDT')).to_i
    else
      dt.to_time.to_i
    end
  end
end
