# Mantle

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

**TODO:** Need to standardize hours, price_range, source_link, website, phone

| attribute     | Facebook           | Foursquare         | Google *pending*   |
| ------------- | ------------------ | ------------------ | ------------------ |
| address       | :white_check_mark: | :white_check_mark: |
| latitude      | :white_check_mark: | :white_check_mark: |
| longitude     | :white_check_mark: | :white_check_mark: |
| phone         | :white_check_mark: | :white_check_mark: |
| source_link   | :white_check_mark: | :white_check_mark: |
| website       | :white_check_mark: | :white_check_mark: |
| hours         | :white_check_mark: | :white_check_mark: |
| price_range   | :white_check_mark: | :white_check_mark: |
| delivery      | :white_check_mark: | :white_check_mark: |
| outdoor       | :white_check_mark: | :white_check_mark: |
| cash_only     | :white_check_mark: | :white_check_mark: |
| kids          | :white_check_mark: | :x:                |
| takeout       | :white_check_mark: | :white_check_mark: |
| reserve       | :white_check_mark: | :white_check_mark: |
| tags          | :white_check_mark: | :white_check_mark: |


### Facebook

`GET /location/facebook/:id`

`id` is the UUID of the location's Facebook page. It can be either the unique numerical UUID like `175495679140580` or the custom UUID like `foundersbrewing`.

Returns a flat JSON object of business information.

```json
{
  "address":"6 Jefferson Ave SE",
  "latitude":42.962910271139,
  "longitude":-85.664197952905,
  "phone":"(616) 233-3219",
  "fb_link":"https://www.facebook.com/pages/Bartertown-Diner/175495679140580",
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

### Foursquare

## Events

*to be implemented*

# License

The MIT License (MIT)
Copyright © 2014 Downtown Grand Rapids Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
