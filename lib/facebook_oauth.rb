require_relative "../models/mantle_setting"
require "koala"

class FacebookOauth
  attr_reader :koala

  def initialize
    @koala = Koala::Facebook::OAuth.new(ENV["FB_APP_ID"], ENV["FB_SECRET"], ENV["FB_OAUTH_REDIRECT"])
  end

  def authorize_url
    @koala.url_for_oauth_code
  end

  def fetch_access_token_from_code(code)
    short_term_token = @koala.get_access_token(code)
    token_info       = @koala.exchange_access_token_info(short_term_token)

    token = MantleSetting.find_or_create(key: "fb_token")
    token.value = token_info["access_token"]
    token.save

    expiration = MantleSetting.find_or_create(key: "fb_expiration")
    expiration.value = (Time.now + token_info["expires"].to_i).to_s
    expiration.save
  end

  def token_set?
    !!MantleSetting.fb_token
  end

  def expiration_set?
    !!MantleSetting.fb_expiration
  end

  def token
    @token ||= MantleSetting.fb_token
  end

  def expiration
    @expiration ||= DateTime.parse(MantleSetting.fb_expiration) if MantleSetting.fb_expiration
  end

  def expiration_date
    expiration.to_date
  end

  def expired?
    expiration < DateTime.now
  end

  def expires_within?(days)
    (expiration_date - days) < Date.today
  end
end
