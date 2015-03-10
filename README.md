# Panatrans API

API for the public bus tranportation system of Ciudad de Panamá (Panamá).



## API Specification 
Specification for developers that plan to make a service or a mobile application based on this API

There are 4 types of resources:

* __Stops__: represent a bus stop. Includes a name and the (latitude, longitude) tuple.
* __Routes__: Represent bus routes, for example: the route from Albrook to Miraflores.
* __Trips__: A route generally has one or two trips. For example, the route Albrook - Miraflores has two trips: (1) the trip from Albrook to Miraflores, and (2) the trip from Miraflores to Albrook. Each trip has a set of stops that may be the same or not. There may be some routes that only have a single trip (ie: circular routes, those that start and end at the same location). 
* __Stop_Sequences__: Is the ordered list of stops for a particular trip. 


### ROUTES

#### GET /routes/
Gets all the routes ordered by name (alphabetical order)


```json 
{
  status : "success"
  data: [{ 
    id: INT,       # 1
    name: STRING,  # "Albrook - Exclusas de Miraflores"
    },
    ...
    ]
  }
}
``` 

#### GET /routes/with_trips
Gets all the routes ordered alphabetically by name and includes the trips linked to each route.

```
{
	status : "success"
	data: [{
		id: INT,  #route id
		name: STRING, # "Route name"
		trips: [{
			id: INT, # trip id
			headsign: STRING,   # "hacia Albrook"
			direction: INT,     # 0=ida, 1= retorno
		}, ...
		]
	}, ...
	]	
}
			
```

#### GET /routes/:id
Returns the information a route identified by `:id`.

```json
{
  status: "success"
  data:  {
  id: INT                  # route id
  name: STRING             # "Albrook - Exclusas de Miraflores" 
  trips: [
    {
      id: INT              # 2, trip id
      headsign: STRING,    # "Hacia Miraflores"
      direction: INT,      # 0 =  ida, 1 = retorno
      stop_sequence: [{
        id: INT,         # stop_sequence id
        sequence: INT    # sequence number,
        stop: {
        	id: INT,         # stop id
        	name: STRING,    # "Albrook"
        	lat: LATITUDE,   # 8.9740946
        	lon: LONGITUDE   # -79.5508536
        	}
        },
        ...
      ]
    },
    ...
  ]
}
```  

#### POST /route/create
Creates a new route

name: STRING
single_trip: true| false


```json
{
  status: "success"
  data:{  
      (same as GET /route/:id)
  }
}
```

If the resource is successfully created it returns code = 1 and the trip 

#### DELETE /route/:id
Deletes the route, its trips and the sequence of stops for each trip

```json
{
  status: "success"
}
``` 



#### PUT /route/:id
Updates a route.

```
route {
	name: STRING
}
```

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


#### DELETE /stops_seuqneces/:id
Removes a stop sequence.


#### DELETE /stop_sequences/trip/:trip_id/stop/:stop_id
Deletes the stop_sequence that links the trip identified by `trip_id` and the stop identified by `stop_id`.


# Additional information

Made for Ruby 2.1.2

#### System dependencies

##### Configuration

##### Deployment instructions

#### Database creation

```
  $ rake db:migrate
``` 
#### Database initialization


#### Database schema



#### How to run the test suite

```
  $ rake test
```

#### Fixtures

 fixtures are stored in `tests/fixtures` and consist in two routes (Albrook - Miraflores, Albrook - Marañón) and each route has two trips and each trip has 4 stops.


 

To load the sample data in your development environment run:

```
rake db:fixtures:load
```


<tt>rake doc:app</tt>.
