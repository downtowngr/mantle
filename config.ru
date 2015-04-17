require "./app"

run Rack::URLMap.new({
  "/nationbuilder" => Mantle::Nationbuilder,
  "/" => Mantle::Api
})