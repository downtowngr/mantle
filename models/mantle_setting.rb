require_relative "../db/load_db"

class MantleSetting < Sequel::Model
  set_dataset $db[:mantle_settings]

  def self.fb_token
    result = self.first(key: "fb_token")
    result.value unless result.nil?
  end

  def self.fb_expiration
    result = self.first(key: "fb_expiration")
    result.value unless result.nil?
  end
end
