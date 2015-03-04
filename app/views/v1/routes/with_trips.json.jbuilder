json.status @status
json.data @routes do |route|
  json.extract! route, :id,:name
  json.trips route.trips, :id, :headsign, :direction
end

