module AttributeHelpers
  require "domainatrix"
  require "phone_wrangler"

  def hour12(time)
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
    else
      "#{digits[0].gsub(/^0/, "")}:#{digits[1]}am"
    end
  end

  def standardize_url(url)
    return nil if url.nil?
    Domainatrix.parse(url.split(" ").first).url
  end

  def standardize_phone(phone)
    return nil if phone.nil?
    return nil if /^[[:alpha:]]/.match(phone)

    number = PhoneWrangler::PhoneNumber.new(phone)
    number.area_code = "616" if number.area_code.nil?
    number.to_s
  end

  def standardize_time(time)
    return nil unless time
    edt = Time.now.strftime("%:z")

    if time.include?("T")
      DateTime.parse(time).new_offset(edt).to_time.to_i
    else
      ymd = time.split("-")
      Time.new(ymd[0], ymd[1], ymd[2], nil, nil, nil, edt).to_i
    end
  end
end