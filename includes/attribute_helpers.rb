module AttributeHelpers
  require "domainatrix"

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
    Domainatrix.parse(url.split(" ").first).url
  end
end