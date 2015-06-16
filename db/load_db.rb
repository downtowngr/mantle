require "sequel"
$db = Sequel.connect(ENV["DATABASE_URL"])
