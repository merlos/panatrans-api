json.prettify! if @prettify
json.status @status
json.data do
  json.extract! @stop, :id, :name, :lat, :lon
  json.routes @stop.routes do |route| 
    json.extract! route, :id, :name
    json.trips @stop.trips do |trip|
      if trip.route_id == route.id
        json.extract! trip, :id, :headsign, :direction, :route_id
      end
    end # trip
  end # route
end # data
  


