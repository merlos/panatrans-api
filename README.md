# Panatrans API

API for the public bus tranportation system of Ciudad de Panamá (Panamá).

## About
Panatrans is a collaborative project to allow the users of the panamenian public transport to create a dataset with the information of the stops and routes available in the City of Panama (which is currently inexistent).

Related Projects:

1. __[panatrans-dataset](https://github.com/merlos/panatrans-dataset)__: dataset to be used with this API.
2. __[panatrans-web](https://github.com/merlos/panatrans-web)__: A javascript web client and editor that makes usage of this API.


# API Specification V1.0 beta
Specification for developers that plan to make a service or a mobile application based on this API.

There are 4 types of resources:

* __Stops__: represent a bus stop. Includes a name and the (latitude, longitude) tuple.
* __Routes__: Represent bus routes, for example: the route from Albrook to Miraflores.
* __Trips__: A route generally has one or two trips. For example, the route Albrook - Miraflores has two trips: (1) the trip from Albrook to Miraflores, and (2) the trip from Miraflores to Albrook. Each trip has a set of stops that may be the same or not. There may be some routes that only have a single trip (ie: circular routes, those that start and end at the same location). 
* __Stop_Sequences__: Is the ordered list of stops for a particular trip. 

This schema is an extreme simplification of the [General Transit Feed Specification (GTFS)](https://developers.google.com/transit/gtfs/) defined by Google. The goal would be to create a GTFS feed.

## ROUTES

#### GET /routes/
Gets all the routes ordered by name (alphabetical order)


```json 
{
  "status" : "success",
  "data" : [{ 
    "id" : INT,       # 1
    "name" : STRING,  # "Albrook - Exclusas de Miraflores"
    },
    ...
    ]
  }
}
``` 
Example:

#### GET /routes/with_trips
Gets all the routes ordered alphabetically by name and includes the trips linked to each route.

```json
{
	"status" : "success"
	"data" : [{
		"id" : INT,  #route id
		"name" : STRING, # "Route name"
		"trips" : [{
			"id": INT, # trip id
			"headsign": STRING,   # "hacia Albrook"
			"direction": INT,     # 0=ida, 1= retorno
		   }, ...
		]}, ...
	 ]	
   }
}			
```
Example: 

#### GET /routes/:id
Returns the information a route identified by `:id`.

```json
{
  "status" : "success"
  "data" :  {
  "id" : INT                  # route id
  "name" : STRING             # "Albrook - Exclusas de Miraflores" 
  "trips" : [
    {
      "id" : INT              # 2, trip id
      "headsign" : STRING,    # "Hacia Miraflores"
      "direction" : INT,      # 0 =  ida, 1 = retorno
      "stop_sequence" : [{
        "id" : INT,         # stop_sequence id
        "sequence" : INT    # sequence number,
        "stop" : {
        	"id" : INT,         # stop id
        	"name" : STRING,    # "Albrook"
        	"lat" : LATITUDE,   # 8.9740946
        	"lon" : LONGITUDE   # -79.5508536
        	}
        },
        ...
      ]
    },
    ...
  ]
}
``` 
Example: 

#### POST /routes/create
Creates a new route

Post data structure:

```
{
 "route": {
 	"name":  STRING;
}
```

Response: 
 
```json
{
  "status": "success"
  "data":{  
      # (see GET /route/:id)
  }
}
```

If the resource is successfully created it returns the resource in `data` (the same response as GET /routes/:id). 

#### DELETE /routes/:id
Deletes the route, its trips and the sequence of stops for each trip


#### PUT /routes/:id
Updates a route.

Put data structure:
```
"route" {
	"name": STRING
}
```

Response:
```json
{
  status: success
  data: {
  	(same as GET /route/:id)
  }
}
``` 

## STOPS

#### GET /stops/
Gets all stops

#### GET /stops/:id

#### POST /stops/

#### PUT /stops/

#### DELETE /stops/:id


## TRIPS

#### GET /trips/
Gets all trips

#### GET /trips/:id

#### POST /trips/

#### PUT /trips/

#### DELETE /trips/:id


## STOP_SEQUENCES
Stop sequences link stop to trips. 

#### GET /stop_sequences/
Gets all stop_sequences


#### GET /stop_sequences/:id
Gets the details of a stop_sequence

The first stop in a trip has `stop_sequence.sequence = 1`.

`stop_sequence.sequence = nil`, means that the order of this stop within the trip is unknown. It may happen that the stop was added to the trip, but it wasn't known the position.


#### POST /stops_sequences/
Adds a stop sequence.

POST structure

```
stop_sequence: {
	sequence: INT,
  unkown_sequence: BOOL, # true = ignores `sequence` and sets it to nil
  trip_id: INT,          # id of the stop to link to the trip
  stop_id: INT           # id of the trip to link the stop.
}
```
Th response is the same as GET /stop_sequences/:id

#### PUT /stops_sequences/:id
Updates a stop sequence.

PUT structure, all the values are optional
```
stop_sequence: {
	sequence: INT,
  unkown_sequence: BOOL, # true = ignores `sequence` and sets it to nil
  trip_id: INT,          # id of the stop to link to the trip
  stop_id: INT           # id of the trip to link the stop.
}
```

Th response is the same as GET /stop_sequences/:id


#### DELETE /stops_sequences/:id
Removes a stop sequence.


#### DELETE /stop_sequences/trip/:trip_id/stop/:stop_id
Deletes the stop_sequence that links the trip identified by `trip_id` and the stop identified by `stop_id`.


## Export

There is a set of calls to get a list of the resources that have been created or changed since a particular date.

These calls are useful either to get a full database dump or to keep track of the hanges changes in the server database (incremental upates, monitoring).

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


# Install your own API server

The API has been developed in Ruby on Rails. It has been tested using Ruby 2.1.2 and Rails 4.1.6.


## How to install: short version
To create a local version of the server API run these commands: 

```
 $ git clone https://github.com/merlos/panatrans-api.git
 $ cd panatrans-api
 $ bundle install
 $ rake db:migrate
 $ rake dataset:update
 $ rails server
```
 
Now you can open your browse at `http://localhost:3000/v1/`, and you'll see the list of API calls available.

You may also want to check the [panatrans-web project](https://github.com/merlos/panatrans-web), that is a web client/editor that makes usage of this API.

## How to install: step by step

#### 1. Download

To get the source code: 

```
$ git clone https://github.com/merlos/panatrans-api.git
```

Install dependencies

```
$ bundle install
```

#### Database creation and initialization

To create the database run the migrations:

```
  $ rake db:migrate
``` 

Then, you can: 

1. Load latest version of the panatrans-dataset:

	```
	$ rake dataset:update
	```

2. Initialize the database with test data:

	```
	$ rake dataset:fixtures
	```
	
	The loaded data is stored in `tests/fixtures/` in Yaml format.

3. Import your own data. First, leave a copy of the csv files in the directory `./tmp/dataset/`. (see [panatrans-dataset](https://github.com/merlos/panatrans-dataset) project, for more info). Then import it:

	```
	$ rake dataset:import
	```

	Please note, that these files are overwritten if you perform a `rake dataset:update` or `rake dataset:download`. 

### Launch the server

```
$ rails server
```
This will launch a server in localhost:3000. All the API calls are at the /v1/ path, so you can open your browser on:

```
http://localhost:3000/v1/
```

And you`ll get a list of available API calls.

## Rake tasks

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
1. V1.0 beta. March 2015. First version.


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