json.prettify! if @prettify
json.status @status
json.data @routes do |route|
  json.extract! route, :id,:name, :url
  if @with_trips
      json.trips route.trips, :id, :headsign, :direction
  end
end

