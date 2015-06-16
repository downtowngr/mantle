require_relative "tasks/generate_bike_parking"
require_relative "tasks/load_experience_gr"
require_relative "tasks/check_fb_token_expiration"

require "dotenv"
require "sequel"

Dotenv.load

task :generate_bike_parking do
  GenerateBikeParking.new.perform
end

task :load_experience_gr do
  LoadExperienceGr.new.perform
end

task :check_fb_token do
  CheckFbTokenExpiration.new.perform
end

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|

    Sequel.extension :migration
    db = Sequel.connect(ENV["DATABASE_URL"])
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "db/migrations")
    end
  end
end
