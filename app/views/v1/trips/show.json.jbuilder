json.prettify! if @prettify
json.status @status
json.data do
  json.extract! @trip, :id, :headsign, :direction
  json.route @trip.route, :id, :name
  json.stops @trip.stop_sequences.includes(:stop).ordered do |sequence|
    json.sequence sequence.sequence
    json.extract! sequence.stop, :id, :name, :lat, :lon
   end
end



