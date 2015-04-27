# Mantle API

[![Build Status](https://img.shields.io/travis/downtowngr/mantle/master.svg?style=flat-square)](https://travis-ci.org/downtowngr/mantle)
[![Code Climate](http://img.shields.io/codeclimate/github/downtowngr/mantle.svg?style=flat-square)](https://codeclimate.com/github/downtowngr/mantle)
[![Test Coverage](http://img.shields.io/codeclimate/coverage/github/downtowngr/mantle.svg?style=flat-square)](https://codeclimate.com/github/downtowngr/mantle)

Service API for Pearl, Downtown Grand Rapids Inc.'s website. Mantle provides a standardized interface for Pearl to access data from various endpoints providing event, business, and location information.

# Getting Started

Within the project's directory, start with this:
```ruby
bundle install

cp .env.example .env
```
Update `.env` with appropriate service tokens. Be sure to set `MANTLE_USER` and `MANTLE_PASS`. You'll need those credentials to access the API.

Type this to run:
```ruby
gem install foreman
foreman start
```

# API

Pearl should assume that every location will be pulling from **one** service per content section (business attributes, events, photos, etc.).

This should allow an administrator of Pearl to determine which source provides the best information per location. For example, Facebook may provide the most accurate business information for Founders, while Foursquare provides the best data for Bartertown.

Mantle provides a standard interface to data per content section provided by a variety of outside services.

### Authentication

Mantle uses Basic Auth. Simply set `MANTLE_USER` and `MANTLE_PASS` to what you want and keep it a secret.

## Location

Location API returns a standardized JSON object of business information pulled from one of several difference services. The request must specify what service to pull from in the path. Currently, the services avaiable are Facebook and Foursquare, identified as `facebook` and `foursquare`, respectively.

Location API requests are construced as such: GET `/location/:service/:service_id`. The `service_id` is the UUID of the location provided by the particular service. Thus, the `service_id` will vary depending on what service's data being requested.

An attribute will return `nil` if the service does not provide the attribute, or if the attribute is not available for the requested location.

| attribute     | Facebook           | Foursquare         | format      |
| ------------- | ------------------ | ------------------ | ----------- |
| address       | :white_check_mark: | :white_check_mark: |             |
| latitude      | :white_check_mark: | :white_check_mark: |             |
| longitude     | :white_check_mark: | :white_check_mark: |             |
| phone         | :white_check_mark: | :white_check_mark: | **string** "(xxx) xxx-xxxx" |
| source_link   | :white_check_mark: | :white_check_mark: |             |
| website       | :white_check_mark: | :white_check_mark: | **string** "http://www.example.com" |
| hours         | :white_check_mark: | :white_check_mark: | **array** "Mon": ["9:00am-5:00pm", "7:00pm-11:00pm"] |
| price_range   | :white_check_mark: | :white_check_mark: |             |
| delivery      | :white_check_mark: | :white_check_mark: | **boolean** |
| outdoor       | :white_check_mark: | :white_check_mark: | **boolean** |
| cash_only     | :white_check_mark: | :white_check_mark: | **boolean** |
| kids          | :white_check_mark: | :x:                | **boolean** |
| takeout       | :white_check_mark: | :white_check_mark: | **boolean** |
| reserve       | :white_check_mark: | :white_check_mark: | **boolean** |
| tags          | :white_check_mark: | :white_check_mark: | **array**   |
| cover_photo   | :white_check_mark: | :x:                |             |
| primary_photo | :white_check_mark: | :x:                |             |

All services return the same flat JSON object of business information.

```json
{ "location":
  {
    "address":"6 Jefferson Ave SE",
    "latitude":42.962910271139,
    "longitude":-85.664197952905,
    "phone":"(616) 233-3219",
    "source_link":"https://www.facebook.com/pages/Bartertown-Diner/175495679140580",
    "website":"http://www.bartertowngr.com",
    "hours": {
      "Mon": ["11:00am-2:00am"],
      "Tue": ["11:00am-2:00am"],
      "Wed": ["11:00am-2:00am"],
      "Thu": ["11:00am-2:00am"],
      "Fri": ["11:00am-2:00am"],
      "Sat": ["11:00am-2:00am"],
      "Sun": ["12:00pm-0:00am"]
    },
    "price_range":"$ (0-10)",
    "tags":["Breakfast & Brunch Restaurant","Vegetarian & Vegan Restaurant","Sandwich Shop","Breakfast","Coffee","Dinner","Lunch"],
    "delivery":false,
    "kids":false,
    "outdoor":true,
    "reserve":false,
    "takeout":true,
    "cash_only":false,
    "cover_photo":"https://fbcdn-sphotos-f-a.akamaihd.net/cover_photo.jpg",
    "primary_photo":"https://fbcdn-sphotos-f-a.akamaihd.net/photo_location.jpg"
  }
}
```

### Facebook

`GET /location/facebook/:id`

`id` is the UUID of the location's Facebook page. It can be either the unique numerical UUID like `175495679140580` or the custom UUID like `foundersbrewing`.

### Foursquare

`GET /location/foursquare/:id`

`id` is the UUID of the location's Foursqure venue. It is an alphanumeric UUID similar to `4b12c269f964a5208b8d23e3`.

## Events

The Events API returns an arry of upcoming events for a given location. The location's ID is the ID from the outside service, similar to the Location API.

The returned `external_id` is the event's UUID identified by the outside service. This attribute should be used to pair and update existing event records within Pearl.

| attribute     | Facebook           | GRNow              | format     |
| ------------- | ------------------ | ------------------ | ---------- |
| event_name    | :white_check_mark: | :white_check_mark: |            |
| start_time    | :white_check_mark: | :white_check_mark: | **timestamp** midnight EDT if all day |
| end_time      | :white_check_mark: | :white_check_mark: | **timestamp** *optional* |
| external_id   | :white_check_mark: | :white_check_mark: |            |
| event_url     | :x:                | :white_check_mark: |            |

```json
{
  "events":[
    {
      "event_name":"REVEREND HORTON HEAT + Nekromantix + Whiskey Shivers @The Pyramid Scheme 6/10",
      "start_time":1431057600,
      "end_time":null,
      "external_id":"1418539731769421",
      "event_url":"http://www.grnow.com/some_event_path"
    }
  ]
}
```

### Facebook

`GET /events/facebook/:id`

### GRNow

`GET /events/grnow/:id`

### ExperienceGR

`GET /events/experiencegr/:id`

## Photos

| attribute     | Instagram          | format     |
| ------------- | ------------------ | ---------- |
| photo_url     | :white_check_mark: |            |
| external_url  | :white_check_mark: |            |
| external_id   | :white_check_mark: |            |

```json
{
  "photos":[
    {
      "photo_url":"http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10963903_1383589831954534_537918980_n.jpg",
      "external_id":"920420860022976241_917430474",
      "external_url":"http://instagram.com/p/zF_eVFh27x/"
    }
  ]
}
```

### Instagram

There are 3 seperate ways to get Instagram images, each depending on the kind of UUID that is being sent.

#### User

Return the 5 most recent images taken by a given Instagram user.

`GET /photos/instagram/user/:id`

#### Facebook

Return the 5 most recent images tagged at the location of this Facebook Page. You can use Facebook Integer UUID or alias like `founderstaproom`.

`GET /photos/instagram/facebook/:id`

#### Foursquare

Return the 5 most recent images tagged at the location of this Foursquare Venue.

`GET /photos/instagram/foursquare/:id`

## Nationbuilder

To subscribe an email to the DGRI mailing list, you will need to `POST` that email to the subscription endpoint:

`POST /nationbuilder/subscription/:email`

- `201` status code if email has been successfully subscribed
- `404` status code if email is invalid or malformed

