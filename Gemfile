source "https://rubygems.org"

ruby "2.1.4"

gem "sinatra"
gem "dotenv"
gem "unicorn"
gem "rake"

gem "koala"
gem "foursquare2"
gem "instagram", github: "pichot/instagram-ruby-gem", branch: "search-location-by-facebook-id"

gem "faraday"
gem "rgeo-geojson"
gem "aws-sdk"
gem "rubyzip"
gem "sequel"
gem "smarter_csv"
gem "domainatrix"
gem "phone_wrangler"
gem "icalendar"
gem "pry"

group :test do
  gem "rspec"
  gem "vcr"
  gem "webmock"
  gem "rack-test"
  gem "codeclimate-test-reporter", require: nil
end

group :development, :test do
  gem "sqlite3"
end