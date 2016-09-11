# Panatrans API

API for the public bus tranportation system of Ciudad de Panamá (Panamá).

[![Build Status](https://travis-ci.org/merlos/panatrans-api.svg)](https://travis-ci.org/merlos/panatrans-api)

[![Code Climate](https://codeclimate.com/github/merlos/panatrans-api/badges/gpa.svg)](https://codeclimate.com/github/merlos/panatrans-api)

[![Test Coverage](https://codeclimate.com/github/merlos/panatrans-api/badges/coverage.svg)](https://codeclimate.com/github/merlos/panatrans-api)

## About
Panatrans is a collaborative project to allow the users of the Panamanian public transport to create a dataset with the information of the stops and routes available in the City of Panama (which was inexistent at the time the project started).

This project is based on the premise that open software and open data are keys on innovation.

Panatrans is divided in four components:

1. __[gtfs_api](https://github.com/merlos/panatrans-dataset)__: The data model. It is an implementation of the [GTFS Specification](https://developers.google.com/transit/gtfs/reference/) in ruby on rails as an engine.  
2. __[panatrans-api](https://github.com/merlos/panatrans-api)__: It is the server side that populates a JSON API based on the data model of gtfs_api. Also written in ruby on rails.
2. __[panatrans-web](https://github.com/merlos/panatrans-web)__: A javascript web client that makes usage of panatrans-api. It is an angularjs application.
3. __[panatrans-dataset](https://github.com/merlos/panatrans-dataset)__: It is the GTFS feed of the Panamanian public transport.


# API Specification V1.1 beta
Specification for developers that plan to make a service or a mobile application based on this API.

This is a JSON RESTful API.

## Conceptual model

This API relies in a schema that is an extreme simplification of the [General Transit Feed Specification (GTFS)](https://developers.google.com/transit/gtfs/) defined by Google.

![Conceptual model of a route](http://www.merlos.org/panatrans-api/conceptual_route.png "Conceptual model of a route")

There are 4 types of resources:

* __Stop__: Represents a bus stop. Includes a name and the (latitude, longitude) tuple.

* __Route__: Represents a bus route, for example: the route from Albrook to Miraflores.

* __Trip__: A route generally has one trip.

* __Stop_Sequence__: Links a trip with a stop to create an ordered list of stops. In the example, the trip Albrook to Miraflores has 4 stops, and therefore it has 4 `stop_sequences`, each one will link one of the stops with that trip. The first stop is Albrook (sequence = 0), then Diablo (sequence = 1), Ciudad del Saber (sequence = 2) and the last one Miraflores (sequence = 3). In GTFS language, `stop_times` are equivalent to `stop_sequences`.

In any call to the API you will be requesting any of these resources.

## Common stuff in API Responses

In every API response there is a "status". Possible values are:

1. `success`. Response data will be set in `data`. HTTP response is always 200 (success). Example:

	<!-- curl -X http://test-panatrans.herokuapp.com/v1/routes/ -->

	```json
	{
	"status":"success",
	"data":[
		{"id":1048002442,"name":"Albrook-Marañón"},
		{"id":219448156,"name":"Vía Brasil-Federico Boyd"}]
	}
	```

2. `fail`, there was a problem performing the operation (ie: incorrect value while creating or updating a resource). The list of problems is passed throught the `errors` object. Example:


	```json
	#curl -X POST --data "stops[name]=2" http://test-panatrans.herokuapp.com/v1/stops/

	{
	  "status":"fail",
	  "errors": {
		"lat":["can't be blank","is not a number"],
		"lon":["can't be blank","is not a number"]
		}
	}
	```

Please see the configuration section below on this file for more info about this mode

## Staging Environment
If you plan to develop a client or a mobile app we recommend you to setup a local instance of Panatrans API (you have the instructions below in the section "Setting up your own panatrans API server"). Also, we've setup a staging environment that you can use to test your app http://test-panatrans.herokuapp.com/.

To release an app that points to the production environment, please contact us by submitting an issue or send a github message to @merlos.

## Examples of usage

Examples of usage of this API are available on the `public/examples/` folder. Live demos:

* [Stop density heatmap](http://test-panatrans.herokuapp.com/examples/heatmap/). Requests stops and displays a heatmap with the density. It uses [jquery](https://jquery.com/), [leaflet](http://leafletjs.com) and [leaflet-heatmap plugin](http://www.patrick-wied.at/static/heatmapjs/).


## ROUTES

### GET /routes/[?with_trips=true]
Gets all the routes ordered by name (alphabetical order)
```
{
	"status" : "success"
	"data" : [{
		"id" : INT,              #route id
		"name" : STRING,         # "Route name"
    "url" : URL,             # url of the route @ mibus.com.pa. May be null

		"trips" : [{  # <-- Only sent if with_trips=true
			"id": INT,            # trip id
			"headsign": STRING,   # "hacia Albrook"
			"direction": INT,     # 0=ida, 1= retorno
		   }, ...
		]}, ...
	 ]
   }
}			
```

`url`is a web address that should have more information about the route. Typically located at mibus.com.pa. Its value may be null.

Example:
http://test-panatrans.herokuapp.com/v1/routes/?prettify=true

Including trips:
http://test-panatrans.herokuapp.com/v1/routes/?with_trips=true&prettify=true

---
__HINT!__ In any request to the api, if you add to the query string the param `?prettify=true`, the output will be a human readable JSON with indentantion and that kind of stuff. Example: `http://panantransserver.org/v1/routes/?prettify=true`

---

### GET /routes/with_trips
Gets all the routes ordered alphabetically by name and includes the trips linked to each route.

Example:

[https://test-panatrans.herokuapp.com/v1/routes/?prettify=true](https://test-panatrans.herokuapp.com/v1/routes/?prettify=true)

### GET /routes/:id[?without_shapes=true]
Returns the detail of the route identified by `:id`.

```
{
  "status" : "success"
  "data" :  {
  "id" : INT                  # route id
  "name" : STRING             # "Albrook - Exclusas de Miraflores"
  "url" : URL,                # URL of the route at mibus.com.pa. May be null
  "trips" : [
    {
      "id" : INT              # 2, trip id
      "headsign" : STRING,    # "Hacia Miraflores"
      "direction" : INT,      # 0 =  ida, 1 = retorno
      "stop_sequences" : [{
        "id" : INT,           # stop_sequence id
        "sequence" : INT      # first is 0
        "stop" : {
        	"id" : INT,         # stop id
        	"name" : STRING,    # "Albrook"
        	"lat" : LATITUDE,   # "8.9740946"
        	"lon" : LONGITUDE   # "-79.5508536"
        	}
        },
        ...
      ],
			shape: [                # <--- Not sent if ?without_shapes=true
				{"id": INT,
				"pt_lat": LATITUDE,
				"pt_lon":LONGITUDE,
				"pt_sequence":INT}]
				},
    	...
  		]
		}, ...
	]
}
```
* `LATITUDE` is a float within the interval (-90, 90).
* `LONGITUDE` is a float within the interval (-180, 180).

Note: in the response latitude and longitude are enclosed in `""`.

Example:

[http://test-panatrans.herokuapp.com/v1/routes/1048002442?prettify=true](http://test-panatrans.herokuapp.com/v1/routes/1048002442?prettify=true)

If the request is successful, it returns the route detail of the updated resource (ie: same as GET /routes/:id).

## STOPS

#### GET /stops/
Gets all stops

```
{
  "status": "success",
  "data": [
    {
      "id": INT,        # 1
      "name": STRING    # "Albrook",
      "lat": LATITUDE   #"8.974095",
      "lon": LONGITUDE  #"-79.550854"
    },...
  ]
 }


```
Example:

[http://test-panatrans.herokuapp.com/v1/stops/?prettify=true](http://test-panatrans.herokuapp.com/v1/stops/?prettify=true)


### GET /stops/:id[?with_stop_sequences=true]
Returns the detail of a stop with id `:id`.

Adding the option `with_stop_sequences=true` the response will include the stop_sequences of each trip that has this stop.

```
{
  "status": "success",
  "data": {
    "id": INT,
    "name": STRING,             # "Albrook",
    "lat": LATITUDE,             # "8.974095",
    "lon": LONGITUDE,            # "-79.550854",
    "routes": [
      {
        "id": INT,
        "name": STRING,          # "Albrook-Marañón",
        "url": URL,              # http://www.mibus.com.pa/rutas
        "trips": [
          {
            "id": INT,
            "headsign": STRING,  # "hacia Marañón",
            "direction": INT,    # 0=> ida/circular, 1=> vuelta,
            "route_id": INT,     # 1048002442

            "stop_sequences": [{  # STOP SEQUENCES ARE ONLY SENT if with_stop_sequences=true
              "id": INT,         # stop_sequence id
              "sequence": INT,      
              "stop_id": INT,
              "trip_id": INT
              },
              ...
            ]
          },
          ...
         ]
      },
      ...
    ]
  }
}
```
Example:

[http://test-panatrans.herokuapp.com/v1/stops/382818451?prettify=true](http://test-panatrans.herokuapp.com/v1/stops/382818451?prettify=true)

[http://test-panatrans.herokuapp.com/v1/stops/382818451?with_stop_sequences=true&prettify=true](http://test-panatrans.herokuapp.com/v1/stops/382818451?with_stop_sequences=true&prettify=true)


####


### GET /v1/stops/nearby/?lat=LATITUDE&lon=LONGITUDE&radius=METERS
Gets the stops in the surroundings of the center `(lat, lon)` within the `radius` (in meters).

```
{
  "status": "success",
  "data": [
    {
      "id": INT,       # stop_id
      "name": STRING   # stop name "Policía Nacional",
      "lat": LONGITUDE # "8.965629",
      "lon": LATITUDE  # "-79.549224",
      "distance": INT  # meters from requested point.
    },
   ]
 }
```
The response returns the stops ordered by ascendent distance.

Example: Get stops close to the point (8.9656294,-79.5492239) and within a radius of 1000m (1km):

http://test-panatrans.herokuapp.com/v1/stops/nearby?lat=8.9656294&lon=-79.5492239&radius=1000&prettify=true



## TRIPS

#### GET /trips/
Gets all trips.

```
{
 "status": "success",
  "data": [
    {
      "id": INT,          # trip id
      "headsign": STRING  # "hacia Albrook",
      "direction": INT,   # 0 => go, 1 => return trip
      "route": {          # route this trip belongs to.
        "id": INT,        # route id
        "name": STRING,   # route name: "Albrook-Panamá Viejo"
        "url": URL,       # route url: http://www.mibus.com.pa/rutas/
      }
    },
	...
  ]
}
```

`direction` is an integer that indicates if the trip is to go or return. 0 means go and 1 means return. For example, in the route "Albrook - Miraflores", the first trip from Albrook to Miraflores has `direction = 0`. The return trip, from Miraflores to Albrook, has `direction = 1`.

Example:

[http://test-panatrans.herokuapp.com/v1/trips?prettify=true](http://test-panatrans.herokuapp.com/v1/trips?prettify=true)


### GET /trips/:id
Gets the detail of the trip with id `:id`. The sequence of stops is returned ordered by sequence number.

A __stop without sequence__ number means that the stop belongs to that trip but the order within the same is unknown.

```
{
  "status": "success",
  "data": {
    "id": INT,           # trip id
    "headsign": STRING   # trip headsign "hacia Marañón",
    "direction": 0,      # trip direction, 0=>go 1=> return
    "route": {
      "id": INT,      # route id
      "name": STRING, # route name "Albrook-Marañón"
      "url": URL,
    },
    "stop_sequences": [
      {
        "id": INT,        # Stops sequence id
        "sequence": 0,    # sequence Number
        "stop": {         
          "id": INT,        # stop id
          "name": STRING    # "Albrook",
          "lat": LATITUDE   # "8.9740946",
          "lon": LONGITUDE  #"-79.5508536"
        }
      },
      ...
      }
    ]
  }
}
```

Example:
[http://test-panatrans.herokuapp.com/v1/trips/1048002442?prettify=true](http://test-panatrans.herokuapp.com/v1/trips/1048002442?prettify=true)


## STOP_SEQUENCES
Stops sequences link stops to trips.

#### GET /stop_sequences/
Gets all stops_sequences

```
{
  "status": "success",
  "data": [
    {
      "id": 13110989,
      "sequence": 3,
      "stop_id": 382818451,
      "trip_id": 665778822
    },...
  ]
}
```
Example:

http://test-panatrans.herokuapp.com/v1/stop_sequences?prettify=true


#### GET /stop_sequences/:id
Gets the details of a stop_sequence

The first stop in a trip has `sequence = 0`.

`stop_sequence.sequence = nil`, means that the order of this stop within the trip is unknown. It may happen that the stop was added to the trip, but it wasn't known the position.

```
{
  "status": "success",
  "data": {
    "id": INT,        # stop_sequence id
    "sequence": INT,  # position in the trip
    "stop": {
      "id": INT,         # stop id
      "name": STRING,    # "Albrook",
      "lat": LATITUDE,   # "8.974095",
      "lon": LONGITUDE   # "-79.550854"
    },
    "trip": {
      "id": INT,         # trip_id
      "headsign": STRING # "hacia Miraflores",
      "direction": INT,  #
      "route": {         
        "id": INT,       # route id
        "name": STRING,  # "Albrook-Miraflores"
        "url": URL       # http://www.mibus.com.pa/rutas/
      }
    }
  }
}
```

Example:

http://test-panatrans.herokuapp.com/v1/stop_sequences/396371388?prettify=true


## Export Calls

There is a set of calls to get the resources that have been created or updated since a particular date.

These calls are useful either to get a full database dump or to keep track of the hanges changes in the server database (incremental upates, monitoring).

__TODO__: Please note that, right now these calls don't include information about deletes (ie: only returns new items that have been created or updated). This is a caveat that is expected to be solved after mergin the features/auditable branch.

The format is the following:

```
GET /v1/:resource/since/:seconds_since_epoc(.csv)
```

Where

* `:resource` can be `stops`,`routes`, `trips` or `stop_sequences`

* `:seconds_since_epoc` is the number of seconds since 1970-01-01 00:00:00 UTC. You can run the command `date +%s`to get the current number of seconds.

* `.csv`: optional parameter to get the dump in CSV format.

Example:

```
# make a dump of the database in CSV
GET /v1/stops/since/0.csv
GET /v1/routes/since/0.csv
GET /v1/trips/since/0.csv
GET /v1/stop_sequences/since/0.csv
```

## Exporting stops to KML and GPX
The API also supports exporting the stops to [Google Earth/Google Maps KML](http://en.wikipedia.org/wiki/Keyhole_Markup_Language) and [GPS Exchange Format (GPX)](http://en.wikipedia.org/wiki/GPS_Exchange_Format). These are the calls:

```
GET /v1/stops.kml
GET /v1/stops.gpx
```

Example:

* http://test-panatrans.herokuapp.com/stops.kml
* http://test-panatrans.herokuapp.com/stops.gpx


# Setting up your own panatrans API server

If you want to set up you own server for development purposes here you have the instructions.

The API has been developed in Ruby on Rails. It has been tested using Ruby 2.1.2 and Rails 4.1.6.

panatrans-api is also [heroku-friendly](http://www.heroku.com), so you can test the project on that environment.

## Setup: short version
To create a local version of the server API run these commands:

```
 $ git clone https://github.com/merlos/panatrans-api.git
 $ cd panatrans-api
 $ bundle install
 $ rake db:migrate
 $ rake gtfs:import[https://github.com/merlos/panatrans-dataset/archive/master.zip] # You can use any GTFS feed
	 # ...
	 # This may take a while
	 # ...
 $ rails server
```

Now you can open your browse at `http://localhost:3000/v1/`, and you'll see the list of API calls available.

You may also want to check the __[panatrans-web project](https://github.com/merlos/panatrans-web)__, a web client developed with [angularjs](https://angularjs.org/) that makes usage of this API.

## Configuration

#### Read only mode (`read_only_mode`)

At this moment, the API only supports read calls (GET). In the future it will support create, update and delete calls.

Read only mode will forbid to change on the database made through JSON API calls. That is, it will disable all the create, update, and delete actions.

In order to activate the `read only mode` (by default is off), you just have to change the variable read_only_mode on the `config/application.rb` file.

```
 # config/application.rb
   config.x.read_only_mode = true
```


## Rake tasks

__TODO these tasks are deprecated and it is pending to clean them.
Meanwhile you should use the rake tasks with the gtfs prefix (use rake -T to get them) documentation of these tasks is available on [gtfs_api project](http://github.com/merlos/gtfs_api)__

This is the list of custom rake tasks developed for the project:

```
rake dataset:download                   # downloads dataset from git (TODO options: DATASET_GIT_URL=github.com/merlos/panatrans-dataset, DATASET_DIR=./tmp/dataset, DATASET_GIT_BRANCH=master]
rake dataset:fixtures                   # Loads development fixtures in current environment database (clears database)
rake dataset:import                     # imports dataset csv files into database (db not cleared) (TODO options: DATASET_DIR=./tmp/dataset/)
rake dataset:reset                      # clears the database and then imports last downloaded csv files
rake dataset:update                     # updates dataset
```

To get a complete list of rake tasks run `rake -T`


#### How to run the test suite

The project includes a set of tests which use the default testing suite that comes with rails (minitest).
To run the tests:

```
  $ rake test
```
More about [test a rails app](http://guides.rubyonrails.org/testing.html).

#### Fixtures

Fixtures are stored in `tests/fixtures`.

To load the sample data in your development environment run:

```
rake dataset:fixtures
```
[More info about fixtures](http://guides.rubyonrails.org/testing.html#the-low-down-on-fixtures).


## Changelog
* March 2015. First release.
* V1.0.0 April 2016. Added only read option (tag v1.0.0)
* V1.1.0 September 2016. Support of GTFS backend. Disabled create, update and delete


# License

Distributed under the MIT License (MIT)

Copyright (c) 2015 Juan M. Merlos

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
