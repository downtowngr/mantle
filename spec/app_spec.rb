require "spec_helper"
require_relative "../app.rb"

RSpec.describe "Mantle" do
  include Rack::Test::Methods

  describe "API" do
    def app() Mantle::Api end

    before do
      authorize ENV["MANTLE_API_USER"], ENV["MANTLE_API_PASS"]
    end

    describe "Not found error" do
      it "returns correct 404 error" do
        get "/location"
        expect(last_response.status).to eq(404)
        expect(JSON.parse(last_response.body)).to eq({"error" => "The requested resource could not be found"})
      end
    end

    describe "GET /location" do
      describe "from Facebook" do
        it "returns a location json object", vcr: {cassette_name: "location_facebook"} do
          get "/location/facebook/foundersbrewing"
          response = JSON.parse(last_response.body)

          expect(response).to eq("location" => {
            "address" => "235 Grandville Ave SW",
            "cash_only" => nil,
            "delivery" => nil,
            "hours" => nil,
            "kids" => nil,
            "latitude" => 42.958605,
            "longitude" => -85.673631,
            "outdoor" => nil,
            "phone" => "(616) 776-2182",
            "price_range" => nil,
            "reserve" => nil,
            "source_link" => "https://www.facebook.com/foundersbrewing",
            "tags" => ["Brewery"],
            "takeout" => nil,
            "website" => "http://www.foundersbrewing.com",
            "cover_photo"=>"https://scontent.xx.fbcdn.net/hphotos-xaf1/t31.0-8/s720x720/10854487_825597074154410_6550122121799297405_o.jpg",
            "primary_photo"=>"https://fbcdn-sphotos-e-a.akamaihd.net/hphotos-ak-xfa1/t31.0-8/1015305_665958910118228_1409354474_o.jpg"
          })
        end

        it "returns 404 if given an incorrect ID", vcr: {cassette_name: "location_facebook_404"} do
          get "/location/facebook/1"
          expect(last_response.status).to eq(404)
          expect(JSON.parse(last_response.body)).to eq({"error" => "The requested Facebook location resource could not be found"})
        end
      end

      describe "from Foursquare" do
        it "returns a location json object", vcr: {cassette_name: "location_foursquare"} do
          get "/location/foursquare/4b12c269f964a5208b8d23e3"
          response = JSON.parse(last_response.body)

          expect(response).to eq("location" => {
            "address"=>"235 Grandville Ave SW",
            "cash_only" => false,
            "delivery" => false,
            "hours"=>{
              "Mon"=>["11:00am-2:00am"],
              "Tue"=>["11:00am-2:00am"],
              "Wed"=>["11:00am-2:00am"],
              "Thu"=>["11:00am-2:00am"],
              "Fri"=>["11:00am-2:00am"],
              "Sat"=>["11:00am-2:00am"],
              "Sun"=>["12:00pm-12:00am"]
            },
            "kids" => nil,
            "latitude" => 42.958428066366515,
            "longitude" => -85.6737289899219,
            "outdoor" => true,
            "phone" => "(616) 776-1195",
            "price_range" => "$$",
            "reserve" => false,
            "source_link" => "https://foursquare.com/v/founders-brewing-co/4b12c269f964a5208b8d23e3",
            "tags" => ["Brewery", "Sandwiches", "Brunch", "Lunch", "Dinner", "Beer", "Wine"],
            "takeout" => false,
            "website" => "http://www.foundersbrewing.com",
          })
        end

        it "returns 404 if given an incorrect ID", vcr: {cassette_name: "location_foursquare_404"} do
          get "/location/foursquare/2"
          expect(last_response.status).to eq(404)
          expect(JSON.parse(last_response.body)).to eq({"error" => "The requested Foursquare location resource could not be found"})
        end
      end
    end

    describe "GET /events" do
      describe "from Facebook" do
        it "returns an array of events", vcr: {cassette_name: "events_facebook"} do
          get "/events/facebook/uicagr"
          response = JSON.parse(last_response.body)

          expect(response).to eq({
            "events" => [
              {
                "event_name"=>"Live Coverage 2015 Presented by Wolverine Worldwide",
                "start_time"=>1431817200,
                "end_time"=>1431831600,
                "external_id"=>"792930544125499"
              },
              {
                "event_name"=>"Mad Max: Beyond the Thunderdome",
                "start_time"=>1431475200,
                "end_time"=>nil,
                "external_id"=>"811168532300298"
              },
              {
                "event_name"=>"Salad Days: A Decade of Punk in Washington, DC (1980-90)",
                "start_time"=>1431057600,
                "end_time"=>nil,
                "external_id"=>"604052006396306"
              },
              {
                "event_name"=>"Art of the Lived Experiment: Family Day",
                "start_time"=>1429981200,
                "end_time"=>1429992000,
                "external_id"=>"1575017596109096"
              },
              {
                "event_name"=>"Art of the Lived Experiment: Family Day",
                "start_time"=>1429376400,
                "end_time"=>1429387200,
                "external_id"=>"1621323388089382"
              },
              {
                "event_name"=>"Art of the Lived Experiment: Family Day",
                "start_time"=>1428771600,
                "end_time"=>1428782400,
                "external_id"=>"462629753891058"
              },
              {
                "event_name"=>"Art of the Lived Experiment: Opening Weekend",
                "start_time"=>1428768000,
                "end_time"=>1428865200,
                "external_id"=>"1557871697835263"
              },
              {
                "event_name"=>"Art of the Lived Experiment: Opening Night",
                "start_time"=>1428703200,
                "end_time"=>1428717600,
                "external_id"=>"1812263592331095"
                }
            ]
          })
        end

        it "returns 404 if given an incorrect ID", vcr: {cassette_name: "events_facebook_404"} do
          get "/events/facebook/1"
          expect(last_response.status).to eq(404)
          expect(JSON.parse(last_response.body)).to eq({"error" => "The requested Facebook events resource could not be found"})
        end
      end

      describe "from GRNow" do
        it "returns array of events", vcr: {cassette_name: "events_grnow"} do
          get "/events/grnow/10074"
          response = JSON.parse(last_response.body)

          expect(response).to eq({
            "events" => [
              {
                "event_name"=>"Hometown Heroes Celebration",
                "start_time"=>1430431200,
                "end_time"=>1430445600,
                "external_id"=>"10697-1430416800-1430431200@http://www.grnow.com",
                "event_url"=>"http://www.grnow.com/event/hometown-heroes-celebration/"
              },
              {
                "event_name"=>"Grand Rapids Comic-Con 2015",
                "start_time"=>1444968000,
                "end_time"=>1445140800,
                "external_id"=>"10750-1444953600-1445126400@http://www.grnow.com",
                "event_url"=>"http://www.grnow.com/event/grand-rapids-comic-con-2015/"
              }
            ]
          })
        end

        it "returns empty array if no events", vcr: {cassette_name: "events_grnow_404"} do
          get "/events/grnow/1000"
          expect(last_response.status).to eq(200)
          expect(JSON.parse(last_response.body)).to eq({"events" => []})
        end
      end

      xdescribe "from Experience GR" do
        it "returns array of events" do
          get "/events/experiencegr/2146"
          response = JSON.parse(last_response.body)

          expect(response).to eq({
            "events" => [
              {
                "event_name"=>"Passionate Expressions",
                "start_time"=>1429761600,
                "end_time"=>nil,
                "external_id"=>"39208",
                "event_url"=>"http://www.scmc-online.org/passionate-expressions/"
              }
            ]
          })
        end

        it "returns empty events array if given an incorrect ID" do
          get "/events/experiencegr/BistroBellaVita"
          expect(JSON.parse(last_response.body)).to eq({"events" => []})
        end
      end
    end

    describe "GET /photos" do
      describe "from Foursquare" do
        it "returns an array of photos", vcr: {cassette_name: "photos_foursquare"} do
          get "/photos/foursquare/4abfea57f964a520f89220e3"
          response = JSON.parse(last_response.body)

          expect(response).to eq({"photos" =>
            [
              {
                "photo_url"=>"https://irs2.4sqi.net/img/general/360x360/51026340_wQ9aPGg1Dopd0NUrKDN1AGQU1tRpe9bg-RSVUuOmHN8.jpg",
                "external_id"=>"534c71dd11d251f5603747de",
                "external_url"=>nil
              },
              {
                "photo_url"=>"https://irs1.4sqi.net/img/general/360x360/51026340_VahiLuFxZZbD7v4a1DL6enVgcc20mwbPDNcvFle2KQ0.jpg",
                "external_id"=>"534c71eb11d251f5603748e5",
                "external_url"=>nil
              },
              {
                "photo_url"=>"https://irs0.4sqi.net/img/general/360x360/51026340_eAVqUsz04P42eal1dejCPVjTZjPW0WbQom7RWTif1qA.jpg",
                "external_id"=>"534c71f911d251f560374a50",
                "external_url"=>nil
              },
              {
                "photo_url"=>"https://irs3.4sqi.net/img/general/360x360/51026340_wG1gSLVcmPdiZDYnvEiLVLRPFUB0naf498ceFvAcSLE.jpg",
                "external_id"=>"534c720b11d251f560374e4f",
                "external_url"=>nil
              },
              {
                "photo_url"=>"https://irs0.4sqi.net/img/general/360x360/51026340_seeCOBZiaF-hZhcu98jpBFLKdOMq8rY8xEjceiqXgO8.jpg",
                "external_id"=>"534c738911d251f560378d95",
                "external_url"=>nil
              }
            ]
          })
        end

        it "returns 404 if Instagram User ID is incorrect", vcr: {cassette_name: "photos_foursquare_404"} do
          get "/photos/foursquare/145271862204424"
          expect(last_response.status).to eq(404)
          expect(JSON.parse(last_response.body)).to eq({"error" => "The requested Foursquare photos resource could not be found"})
        end
      end

      describe "from Instagram" do
        it "returns an array of photos", vcr: {cassette_name: "photos_instagram"} do
          get "/photos/instagram/downtowngrinc"
          response = JSON.parse(last_response.body)

          expect(response).to eq({"photos" =>
            [
              {
                "photo_url"=>"http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10963903_1383589831954534_537918980_n.jpg",
                "external_id"=>"920420860022976241_917430474",
                "external_url"=>"http://instagram.com/p/zF_eVFh27x/"
              },
              {
                "photo_url"=>"http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10956616_697567707022397_582367148_n.jpg",
                "external_id"=>"919069369106394313_917430474",
                "external_url"=>"http://instagram.com/p/zBMLjFh2zJ/"
              },
              {
                "photo_url"=>"http://scontent-b.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10952992_332530126950683_1054510574_n.jpg",
                "external_id"=>"907948958172015756_917430474",
                "external_url"=>"http://instagram.com/p/yZrsRWB2yM/"
              },
              {
                "photo_url"=>"http://scontent-b.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10903366_899477276751454_249379378_n.jpg",
                "external_id"=>"906591648556216175_917430474",
                "external_url"=>"http://instagram.com/p/yU3E0Qh29v/"
              },
              {
                "photo_url"=>"http://scontent-b.cdninstagram.com/hphotos-xfa1/t51.2885-15/e15/10899518_1523565954584097_1800298994_n.jpg",
                "external_id"=>"900009100812185569_917430474",
                "external_url"=>"http://instagram.com/p/x9eYI8h2_h/"
              }
            ]
          })
        end

        it "returns 404 if Instagram User ID is incorrect", vcr: {cassette_name: "photos_instagram_404"} do
          get "/photos/instagram/145271862204424"
          expect(last_response.status).to eq(404)
          expect(JSON.parse(last_response.body)).to eq({"error" => "The requested Instagram photos resource could not be found"})
        end
      end
    end
  end
end
