json.prettify! if @prettify
json.status @status
json.data @trips do |trip|
  json.extract! trip, :id, :headsign, :direction
  json.route trip.route, :id, :name
end



