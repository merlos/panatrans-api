json.status @status
json.data do
  json.extract! @stop, :id, :name, :lat, :lon
  json.routes @stop.routes, :id, :name
  json.trips @stop.trips do |trip|
    json.extract! trip, :id, :headsign, :direction, :route_id
  end
end
  


