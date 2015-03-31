require_relative "tasks/generate_bike_parking"
require_relative "tasks/generate_transit_stops"

require "dotenv"

Dotenv.load

task :generate_bike_parking do
  GenerateBikeParking.new.perform
end

task :generate_transit_stops do
  GenerateTransitStops.new.perform
end