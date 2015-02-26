require "spec_helper"
require_relative "../app.rb"

RSpec.describe "Mantle" do
  before do
    authorize ENV["MANTLE_USER"], ENV["MANTLE_PASS"]
  end

  describe "GET /location" do
    describe "from Facebook", vcr: {cassette_name: "location_facebook"} do
      it "returns a location json object" do
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
          "website" => "www.foundersbrewing.com",
        })
      end
    end

    describe "from Foursquare", vcr: {cassette_name: "location_foursquare"}  do
      it "returns a location json object" do
        get "/location/foursquare/4b12c269f964a5208b8d23e3"

        response = JSON.parse(last_response.body)

        expect(response).to eq("location" => {
          "address"=>"235 Grandville Ave SW",
          "cash_only" => false,
          "delivery" => false,
          "hours" => "Mon–Sat 11:00 AM–2:00 AM Sun Noon–Midnight",
          "kids" => nil,
          "latitude" => 42.958428066366515,
          "longitude" => -85.6737289899219,
          "outdoor" => true,
          "phone" => "(616) 776-1195",
          "price_range" => "$$",
          "reserve" => false,
          "source_link" => "https://foursquare.com/v/founders-brewing-co/4b12c269f964a5208b8d23e3",
          "tags" => ["Brunch", "Lunch", "Dinner", "Beer", "Wine", "Brewery", "Sandwiches"],
          "takeout" => false,
          "website" => "http://www.foundersbrewing.com",
        })
      end
    end
  end

  describe "GET /events" do
    describe "from Facebook", vcr: {cassette_name: "events_facebook"} do
      it "returns an array of events" do
        get "/events/facebook/uicagr"

        response = JSON.parse(last_response.body)

        expect(response).to eq({
          "events" => [
            {
              "event_name"=>"Bring Your Own Beamer Grand Rapids 02",
              "start_time"=>"2015-03-06T18:00:00-0500",
              "end_time"=>"2015-03-06T23:00:00-0500",
              "external_id"=>"1547366848875583"
            },
            {
              "event_name"=>"Open Projector Night No. 10",
              "start_time"=>"2015-02-18T20:00:00-0500",
              "end_time"=>nil,
              "external_id"=>"559480167521476"
            },
            {
              "event_name"=>"Portraits by James LaCroix: Opening Reception",
              "start_time"=>"2015-02-13T18:00:00-0500",
              "end_time"=>"2015-02-13T20:00:00-0500",
              "external_id"=>"900554633308138"
            },
            {
              "event_name"=>"Looking Forward Collector's Talk and Silent Auction",
              "start_time"=>"2015-02-06T19:00:00-0500",
              "end_time"=>"2015-02-06T20:00:00-0500","external_id"=>"1408844586079669"
            }
          ]
        })
      end
    end
  end

  describe "GET /photos" do
    describe "from Instagram" do
      context "with Instagram user alias", vcr: {cassette_name: "photos_instagram_user"} do
        it "returns an array of photos" do
          get "/photos/instagram/user/downtowngrinc"

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
      end

      context "with Facebook ID", vcr: {cassette_name: "photos_instagram_facebook"} do
        it "returns an array of photos" do
          get "/photos/instagram/facebook/founderstaproom"

          response = JSON.parse(last_response.body)

          expect(response).to eq({"photos" =>
            [
              {
                "photo_url"=>"http://scontent-b.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10946548_391949857644569_1028718600_n.jpg",
                "external_id"=>"922148850541115954_512555621",
                "external_url"=>"http://instagram.com/p/zMIX5qiboy/"
              },
              {
                "photo_url"=>"http://scontent-b.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10959225_348598685342143_1299088171_n.jpg",
                "external_id"=>"920688466242498156_280333002",
                "external_url"=>"http://instagram.com/p/zG8UgzLu5s/"
              },
              {
                "photo_url"=>"http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10953087_1017722664922078_364453478_n.jpg",
                "external_id"=>"919720702503172059_13034492",
                "external_url"=>"http://instagram.com/p/zDgRslRjfb/"
              },
              {
                "photo_url"=>"http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10946674_1577261472513826_512377860_n.jpg",
                "external_id"=>"917763957854516465_377531228",
                "external_url"=>"http://instagram.com/p/y8jXUHkzTx/"
              },
              {
                "photo_url"=>"http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10986114_1604680426432313_1538301330_n.jpg",
                "external_id"=>"917759177144874133_377531228",
                "external_url"=>"http://instagram.com/p/y8iRvvEzSV/"
              }
            ]
          })
        end
      end

      context "with Foursquare ID", vcr: {cassette_name: "photos_instagram_foursquare"} do
        it "returns an array of photos" do
          get "/photos/instagram/foursquare/4b12c269f964a5208b8d23e3"

          response = JSON.parse(last_response.body)

          expect(response).to eq({"photos" =>
            [
              {
                "photo_url"=>"http://scontent-b.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10946548_391949857644569_1028718600_n.jpg",
                "external_id"=>"922148850541115954_512555621",
                "external_url"=>"http://instagram.com/p/zMIX5qiboy/"
              },
              {
                "photo_url"=>"http://scontent-b.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10959225_348598685342143_1299088171_n.jpg",
                "external_id"=>"920688466242498156_280333002",
                "external_url"=>"http://instagram.com/p/zG8UgzLu5s/"
              },
              {
                "photo_url"=>"http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10953087_1017722664922078_364453478_n.jpg",
                "external_id"=>"919720702503172059_13034492",
                "external_url"=>"http://instagram.com/p/zDgRslRjfb/"
              },
              {
                "photo_url"=>"http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10946674_1577261472513826_512377860_n.jpg",
                "external_id"=>"917763957854516465_377531228",
                "external_url"=>"http://instagram.com/p/y8jXUHkzTx/"
              },
              {
                "photo_url"=>"http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10986114_1604680426432313_1538301330_n.jpg",
                "external_id"=>"917759177144874133_377531228",
                "external_url"=>"http://instagram.com/p/y8iRvvEzSV/"
              }
            ]
          })
        end
      end
    end
  end
end