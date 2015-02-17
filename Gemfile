source "https://rubygems.org"

ruby "2.1.4"

gem "sinatra"
gem "dotenv"
gem "unicorn"

gem "koala"
gem "foursquare2"
gem "instagram", github: "pichot/instagram-ruby-gem", branch: "search-location-by-facebook-id"

group :test do
  gem "rspec"
  gem "vcr"
  gem "webmock"
  gem "rack-test"
  gem "codeclimate-test-reporter", require: nil
end

group :development, :test do
  gem "pry"
end