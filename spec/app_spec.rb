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
          "website" => "http://www.foundersbrewing.com",
          "cover_photo"=>"https://scontent.xx.fbcdn.net/hphotos-xaf1/t31.0-8/s720x720/10854487_825597074154410_6550122121799297405_o.jpg",
          "primary_photo"=>"https://fbcdn-sphotos-e-a.akamaihd.net/hphotos-ak-xfa1/t31.0-8/1015305_665958910118228_1409354474_o.jpg"
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
          "hours"=>{
            "Mon"=>["11:00am-2:00am"],
            "Tue"=>["11:00am-2:00am"],
            "Wed"=>["11:00am-2:00am"],
            "Thu"=>["11:00am-2:00am"],
            "Fri"=>["11:00am-2:00am"],
            "Sat"=>["11:00am-2:00am"],
            "Sun"=>["12:00pm-0:00am"]
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
              "event_name"=>"Live Coverage 2015 Presented by Wolverine Worldwide",
              "start_time"=>"2015-05-16T19:00:00-0400",
              "end_time"=>"2015-05-16T23:00:00-0400",
              "external_id"=>"792930544125499"
            },
            {
              "event_name"=>"Mad Max: Beyond the Thunderdome",
              "start_time"=>"2015-05-12T20:00:00-0400",
              "end_time"=>nil,
              "external_id"=>"811168532300298"
            },
            {
              "event_name"=>"Salad Days: A Decade of Punk in Washington, DC (1980-90)",
              "start_time"=>"2015-05-08",
              "end_time"=>nil,
              "external_id"=>"604052006396306"
            },
            {
              "event_name"=>"Art of the Lived Experiment: Family Day",
              "start_time"=>"2015-04-25T13:00:00-0400",
              "end_time"=>"2015-04-25T16:00:00-0400",
              "external_id"=>"1575017596109096"
            },
            {
              "event_name"=>"Art of the Lived Experiment: Family Day",
              "start_time"=>"2015-04-18T13:00:00-0400",
              "end_time"=>"2015-04-18T16:00:00-0400",
              "external_id"=>"1621323388089382"
            },
            {
              "event_name"=>"Art of the Lived Experiment: Family Day",
              "start_time"=>"2015-04-11T13:00:00-0400",
              "end_time"=>"2015-04-11T16:00:00-0400",
              "external_id"=>"462629753891058"
            },
            {
              "event_name"=>"Art of the Lived Experiment: Opening Weekend",
              "start_time"=>"2015-04-11T12:00:00-0400",
              "end_time"=>"2015-04-12T15:00:00-0400",
              "external_id"=>"1557871697835263"
            },
            {
              "event_name"=>"Art of the Lived Experiment: Opening Night",
              "start_time"=>"2015-04-10T18:00:00-0400",
              "end_time"=>"2015-04-10T22:00:00-0400",
              "external_id"=>"1812263592331095"
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

          expect(response).to eq({
            "photos" =>
              [
                {
                  "photo_url"=>"https://scontent.cdninstagram.com/hphotos-xfa1/t51.2885-15/e15/11094476_1080529151963799_1068529237_n.jpg",
                  "external_id"=>"953533469508992301_680478",
                  "external_url"=>"https://instagram.com/p/07oaNzh30t/"
                },
                {
                  "photo_url"=>"https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/11007922_745080938924401_1294719765_n.jpg",
                  "external_id"=>"953238980180519173_179503529",
                  "external_url"=>"https://instagram.com/p/06lc1PtykF/"
                },
                {
                  "photo_url"=>"https://scontent.cdninstagram.com/hphotos-xpf1/t51.2885-15/e15/10665359_1567845736818861_2008160158_n.jpg",
                  "external_id"=>"953192452010032532_16922318",
                  "external_url"=>"https://instagram.com/p/06a3wgpD2U/"
                },
                {
                  "photo_url"=>"https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/11111419_875459132500517_57156612_n.jpg",
                  "external_id"=>"953153044050351305_32203332",
                  "external_url"=>"https://instagram.com/p/06R6S_NBTJ/"
                },
                {
                  "photo_url"=>"https://scontent.cdninstagram.com/hphotos-xap1/t51.2885-15/e15/10560913_1402029653447498_788262347_n.jpg",
                  "external_id"=>"951141777009797400_262318321",
                  "external_url"=>"https://instagram.com/p/0zImgls-kY/"
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