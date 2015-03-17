json.prettify! if @prettify
json.status @status
json.data do
  json.extract! @stop_sequence, :id, :sequence
  json.stop @stop_sequence.stop, :id, :name, :lat, :lon
  json.trip do
    json.extract! @stop_sequence.trip, :id, :headsign, :direction
    json.route @stop_sequence.trip.route, :id, :name
  end
end
  