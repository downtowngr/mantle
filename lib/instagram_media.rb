class InstagramMedia
  def initialize(id, feed)
    @client = Instagram.client(client_id: ENV["INSTAGRAM_ID"])
    @photos = @client.send("#{feed}_recent_media", id)
  end

  def photos
    photos = []
    number = [5, @photos.count].min
    count  = 0

    @photos.each do |p|
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

  def self.from_user(instagram_id)
    user = Instagram.client(client_id: ENV["INSTAGRAM_ID"]).user_search(instagram_id)
    user ? self.new(user.first["id"], :user) : nil
  end

  def self.from_facebook(facebook_id)
    if facebook_id.to_i == 0
      page = Koala::Facebook::API.new(ENV["FB_TOKEN"]).get_object(facebook_id)
      facebook_id = page["id"]
    end

    location = Instagram.client(client_id: ENV["INSTAGRAM_ID"]).location_search_facebook_places_id(facebook_id)
    location ? self.new(location.first["id"], :location) : nil
  end

  def self.from_foursquare(foursquare_id)
    location = Instagram.client(client_id: ENV["INSTAGRAM_ID"]).location_search(foursquare_id)
    location ? self.new(location.first["id"], :location) : nil
  end
end