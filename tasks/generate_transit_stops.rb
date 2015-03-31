require "open-uri"
require "zip"
require "sqlite3"
require "sequel"
require "rgeo/geo_json"
require "smarter_csv"
require "aws-sdk"

class GenerateTransitStops
  def initialize
    Dir.mkdir "tmp" unless File.exists?("tmp")
    SQLite3::Database.new("tmp/gtfs.db")
    @db    = Sequel.connect('sqlite://tmp/gtfs.db')

    @coder = RGeo::GeoJSON.coder
    @bb = RGeo::Cartesian::BoundingBox.create_from_points(
      @coder.geo_factory.point(-85.68291485309601, 42.97696419731116),
      @coder.geo_factory.point(-85.65665602684021, 42.95390977598836)
    )

    @s3_file = Aws::S3::Object.new("dgri-web", "maps/transit_stops.geojson", {
      access_key_id: ENV["AWS_SECRET_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: "us-east-1"
    })

    @gtfs_files = ["stops.txt", "routes.txt", "trips.txt", "stop_times.txt"]
    @layer_path = "tmp/transit_stops.geojson"
  end

  def perform
    fetch_gtfs("tmp/gtfs.zip")
    unzip_gtfs("tmp/gtfs.zip")

    @gtfs_files.each {|f| populate_db(f)}

    File.write(@layer_path, @coder.encode(feature_collection).to_json)
    @s3_file.upload_file(@layer_path, acl: "public-read")
  end

  def feature_collection
    features = @db[:stops].all.map do |stop|
      stop_point = @coder.geo_factory.point(stop[:stop_lon], stop[:stop_lat])
      next unless @bb.contains?(stop_point)

      trip_ids = @db[:stop_times].where(stop_id: stop[:stop_id]).select(:trip_id).all.map {|s| s[:trip_id]}
      next if trip_ids.empty?

      route_names = trip_ids.uniq.map do |trip_id|
        route_id = @db[:trips].where(trip_id: trip_id).first[:route_id]
        @db[:routes].where(route_id: route_id).first[:route_short_name]
      end

      routes = route_names.uniq

      @coder.entity_factory.feature(
        @coder.geo_factory.point(stop[:stop_lon], stop[:stop_lat]),
        stop[:stop_id],
        {stop_number: stop[:stop_code], name: stop[:stop_name], routes: routes}
      )
    end

    @coder.entity_factory.feature_collection(features)
  end

  def populate_db(filename)
    tablename = File.basename(filename).gsub(/\.\w+/,"").to_sym

    options = {strings_as_keys: true, remove_empty_values: false, remove_zero_values: false}
    data = SmarterCSV.process("tmp/#{filename}", options)

    @db.drop_table? tablename

    @db.create_table tablename do
      data.last.each do |column_name, row|
        if row.class == NilClass
          klass = String
        else
          klass = row.class
        end

        column column_name, klass
      end
    end

    data.each do |row|
      @db[tablename].insert(row)
    end
  end

  def unzip_gtfs(gtfs_zip)
    Zip::File.open(gtfs_zip) do |zip_file|
      @gtfs_files.each do |filename|
        File.delete("tmp/#{filename}") if File.exists?("tmp/#{filename}")
        entry = zip_file.glob(filename).first
        entry.extract("tmp/#{filename}")
      end
    end
  end

  def fetch_gtfs(gtfs_zip)
    open(gtfs_zip, 'wb') do |file|
      file << open('http://connect.ridetherapid.org/InfoPoint/gtfs-zip.ashx').read
    end
  end
end


