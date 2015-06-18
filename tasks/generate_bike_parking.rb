require "faraday"
require "aws-sdk"
require "rgeo/geo_json"
require "json"
require "json/minify"

class GenerateBikeParking
  def initialize
    Dir.mkdir "tmp" unless File.exists?("tmp")

    @conn = Faraday.new(url: 'http://www.overpass-api.de') do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end

    @coder   = RGeo::GeoJSON.coder
    @s3_file = Aws::S3::Object.new(ENV["AWS_BUCKET"], "maps/bike_parking.geojson", {
      access_key_id: ENV["AWS_SECRET_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: "us-east-1"
    })

    @tmp_path = "tmp/bike_parking.geojson"
  end

  def perform
    File.write(@tmp_path, JSON.minify(@coder.encode(feature_collection).to_json))
    @s3_file.upload_file(@tmp_path, acl: "public-read")
  end

  def feature_collection
    features = parking_nodes.map do |node|

      @coder.entity_factory.feature(
        @coder.geo_factory.point(node["lon"], node["lat"]),
        node["id"],
        {
          amenity: node["tags"]["amenity"],
          type: node["tags"]["bicycle_parking"],
          capacity: node["tags"]["capacity"]
        }
      )
    end

    @coder.entity_factory.feature_collection(features)
  end

  private

  def parking_nodes
    @osm_data ||= @conn.get "/api/interpreter", {
      data: '[out:json][timeout:25];(node["amenity"="bicycle_parking"](42.95390977598836, -85.68291485309601, 42.97696419731116, -85.65665602684021);node["amenity"="bicycle_repair_station"](42.95390977598836, -85.68291485309601, 42.97696419731116, -85.65665602684021););out body;>;out skel qt;'
    }

    JSON.parse(@osm_data.body)["elements"]
  end
end
