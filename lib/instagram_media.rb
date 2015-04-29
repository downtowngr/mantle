class InstagramMedia
  def initialize(username)
    @client   = Instagram.client(client_id: ENV["INSTAGRAM_ID"])
    @username = username
  end

  def photos
    photos = []
    number = [5, photo_array.count].min
    count  = 0

    photo_array.each do |p|
      break if count == number
      next if p["type"] != "image"

      photos << {
        photo_url:    p["images"]["standard_resolution"]["url"],
        external_id:  p["id"],
        external_url: p["link"]
      }

      count += 1
    end

    {photos: photos}
  end

  private

  def photo_array
    @photo_array ||= @client.send("user_recent_media", user.id)
  end

  def user
    @user ||= @client.user_search(@username)
    if @user.empty? || @user.first.username != @username
      raise MissingResourceError, "Instagram photos"
    end
    @user.first
  end
end