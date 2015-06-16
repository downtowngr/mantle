require "dotenv"
Dotenv.load

task :generate_bike_parking do
  require_relative "tasks/generate_bike_parking"
  GenerateBikeParking.new.perform
end

task :load_experience_gr do
  require_relative "tasks/load_experience_gr"
  LoadExperienceGr.new.perform
end

task :check_fb_token do
  require_relative "tasks/check_fb_token_expiration"
  CheckFbTokenExpiration.new.perform
end

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    require "sequel"

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
