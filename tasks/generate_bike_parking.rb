require "faraday"
require "aws-sdk"
require "rgeo/geo_json"
require "json"

class GenerateBikeParking
  def initialize
    @conn = Faraday.new(url: 'http://www.overpass-api.de') do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end

    @coder   = RGeo::GeoJSON.coder
    @s3_file = Aws::S3::Object.new("dgri-web", "maps/bike_parking.geojson", {
      access_key_id: ENV["AWS_SECRET_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: "us-east-1"
    })

    @tmp_path = "bike_parking.geojson"
  end

  def perform
    File.write(@tmp_path, @coder.encode(feature_collection).to_json)
    @s3_file.upload_file(@tmp_path, acl: "public-read")
  end

  def feature_collection
    features = parking_nodes.map do |node|

      @coder.entity_factory.feature(
        @coder.geo_factory.point(node["lon"], node["lat"]),
        node["id"],
        {type: node["tags"]["bicycle_parking"], capacity: node["tags"]["capacity"]}
      )
    end

    @coder.entity_factory.feature_collection(features)
  end

  private

  def parking_nodes
    @osm_data ||= @conn.get "/api/interpreter", {
      data: '[out:json][timeout:25];(node["amenity"="bicycle_parking"](42.85633644214852,-85.78742980957031,43.03100396557044,-85.54573059082031););out body;>;out skel qt;'
    }

    JSON.parse(@osm_data.body)["elements"]
  end
end

