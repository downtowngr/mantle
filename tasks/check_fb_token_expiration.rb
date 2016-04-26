require_relative "../lib/facebook_oauth"
require "sequel"
require "pony"

class CheckFbTokenExpiration
  def initialize
    @db = Sequel.connect(ENV["DATABASE_URL"])
  end

  def perform
    if FacebookOauth.new.expires_within?(ENV["FB_TOKEN_EXPIRY_DAYS"].to_i)
      Pony.mail(
        to:   "info@downtowngr.org",
        from: "DGRI Mantle <no-reply@dgri-mantle.herokuapp.com>",
        subject: "[Website] Facebook Needs Reauthorization",
        via: :smtp,
        via_options: {
          address: "smtp.sendgrid.net",
          port: "587",
          user_name: ENV["SENDGRID_USERNAME"],
          password: ENV["SENDGRID_PASSWORD"]
        },
        body: body
      )
    end
  end

  private

  def body
    <<-BODY
This is an automated reminder that you will need to reauthorize Facebook to continue pulling location metadata for downtowngr.org.

Use the username (#{ENV["MANTLE_ADMIN_USER"]}) and password (#{ENV["MANTLE_ADMIN_PASS"]}) to login here http://dgri-mantle.herokuapp.com/admin

Click 'Authorize Facebook'. Facebook should guide you through the process. Once completed, your token should be renewed.

You will need to do this about every 2 months. You will receive this email as a reminder a week before the expiration of Facebook authorization.
    BODY
  end
end
