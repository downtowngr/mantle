# Mantle

[![Build Status](https://img.shields.io/travis/downtowngr/mantle/master.svg?style=flat-square)](https://travis-ci.org/downtowngr/mantle)
[![Code Climate](http://img.shields.io/codeclimate/github/downtowngr/mantle.svg?style=flat-square)](https://codeclimate.com/github/downtowngr/mantle)
[![Test Coverage](http://img.shields.io/codeclimate/coverage/github/downtowngr/mantle.svg?style=flat-square)](https://codeclimate.com/github/downtowngr/mantle)

Service API for Pearl, Downtown Grand Rapids Inc.'s website. Mantle provides a standardized interface for Pearl to access data from various endpoints providing event, business, and location information.

# Getting Started

```ruby
bundle install

gem install foreman
foreman start
```

# API

## Location API

Location API returns a standardized JSON object of business information pulled from one of several difference services. The request must specify what service to pull from in the path. Currently, the services avaiable are Facebook, Foursquare, and Google, identified as `facebook`, `foursquare`, or `google`, respectively. This allows an administrator of Pearl to determine which source provides the best information per location. For example, Facebook may provide the best data for Founders, while Foursquare provides the best data for Bartertown.

Location API requests are construced as such: GET `/location/:service/:service_id`. The `service_id` is the UUID of the location provided by the particular service. Thus, the `service_id` will vary depending on what service's data being requested.

An attribute will return `nil` if the service does not provide the attribute, or if the attribute is not available for the requested location.

**TODO:** Need to standardize output of `hours`, `price_range`, `website`, `phone`

| attribute     | Facebook           | Foursquare         | format |
| ------------- | ------------------ | ------------------ | ------ |
| address       | :white_check_mark: | :white_check_mark: |        |
| latitude      | :white_check_mark: | :white_check_mark: |        |
| longitude     | :white_check_mark: | :white_check_mark: |        |
| phone         | :white_check_mark: | :white_check_mark: | **string** "(xxx) xxx-xxxx" |
| source_link   | :white_check_mark: | :white_check_mark: |        |
| website       | :white_check_mark: | :white_check_mark: | **string** "http://www.example.com" |
| hours         | :white_check_mark: | :white_check_mark: |        |
| price_range   | :white_check_mark: | :white_check_mark: |        |
| delivery      | :white_check_mark: | :white_check_mark: | **boolean** |
| outdoor       | :white_check_mark: | :white_check_mark: | **boolean** |
| cash_only     | :white_check_mark: | :white_check_mark: | **boolean** |
| kids          | :white_check_mark: | :x:                | **boolean** |
| takeout       | :white_check_mark: | :white_check_mark: | **boolean** |
| reserve       | :white_check_mark: | :white_check_mark: | **boolean** |
| tags          | :white_check_mark: | :white_check_mark: | **array** |

All services return the same flat JSON object of business information.

```json
{
  "address":"6 Jefferson Ave SE",
  "latitude":42.962910271139,
  "longitude":-85.664197952905,
  "phone":"(616) 233-3219",
  "source_link":"https://www.facebook.com/pages/Bartertown-Diner/175495679140580",
  "website":"www.bartertowngr.com",
  "hours":"Mon 11:00am-3:00pm Wed 11:00am-9:00pm Thu 11:00am-9:00pm 10:00pm-03:00am Fri 11:00am-9:00pm 10:00pm-03:00am Sat 09:00am-9:00pm 10:00pm-03:00am Sun 09:00am-2:00pm",
  "price_range":"$ (0-10)",
  "tags":["Breakfast & Brunch Restaurant","Vegetarian & Vegan Restaurant","Sandwich Shop","Breakfast","Coffee","Dinner","Lunch"],
  "delivery":false,
  "kids":false,
  "outdoor":true,
  "reserve":false,
  "takeout":true,
  "cash_only":false
}
```

### Facebook

`GET /location/facebook/:id`

`id` is the UUID of the location's Facebook page. It can be either the unique numerical UUID like `175495679140580` or the custom UUID like `foundersbrewing`.

### Foursquare

`GET /location/foursquare/:id`

`id` is the UUID of the location's Foursqure venue. It is an alphanumeric UUID similar to `4b12c269f964a5208b8d23e3`.

## Events API

### ExperienceGR

`GET /events/experiencegr/:id`

*to be implemented*

## Photos API

*to be implemented*

# License

The MIT License (MIT)
Copyright © 2014 Downtown Grand Rapids Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
