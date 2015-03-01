# Panatrans API

API for the public bus tranportation system of Ciudad de Panamá (Panamá).



## API Specification 
Specification for developers that plan to make a service or a mobile application based on this API

There are 4 types of resources:

* __Stops__: represent a bus stop. Includes a name and the (latitude, longitude) tuple.
* __Routes__: Represent bus routes, for example: the route from Albrook to Miraflores.
* __Trips__: A route generally has one or two trips. For example, the route Albrook - Miraflores has two trips: (1) the trip from Albrook to Miraflores, and (2) the trip from Miraflores to Albrook. Each trip has a set of stops that may be the same or not. There may be some routes that only have a single trip (ie: circular routes, those that start and end at the same location). 
* __Stop_Sequences__: Is the ordered list of stops for a particular trip. 


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

### GET /routes/:id
Returns the information a route identified by `:id`.

```json
{
  status: "success"
  data:  {
  id: INT                  # 1
  name: STRING             # "Albrook - Exclusas de Miraflores" 
  trips: [
    {
      id: INT              # 2, trip identifier
      headsign: STRING,    # "Hacia Miraflores"
      direction: INT,      # 0 => ida, 1 => retorno
      stops: [{
        sequence: INT    # sequence,
        id: INT,         # 3 
        name: STRING,    # "Albrook"
        lat: LATITUDE,   # 8.9740946
        lon: LONGITUDE   # -79.5508536
        },
        ...
      ]
    },
    ...
  ]
}
```  

### POST /route/create
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

### DELETE /route/:id
Deletes the route, its trips and the sequence of stops for each trip

```json
{
  status: "success"
}
``` 



### PUT /route/:id
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
