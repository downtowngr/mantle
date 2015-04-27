require_relative "tasks/generate_bike_parking"
require_relative "tasks/load_experience_gr"

require "dotenv"

Dotenv.load

task :generate_bike_parking do
  GenerateBikeParking.new.perform
end

task :load_experience_gr do
  LoadExperienceGr.new.perform
end