require "./app"
require "airbrake"

configure :production do
  Airbrake.configure do |config|
    config.api_key = ENV["AIRBRAKE_API_KEY"]
  end
  use Airbrake::Sinatra
end

run Rack::URLMap.new({
  "/admin" => Mantle::Admin,
  "/" => Mantle::Api
})
