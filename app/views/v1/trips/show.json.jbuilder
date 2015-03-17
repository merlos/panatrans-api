json.prettify! if @prettify
json.status @status
json.data do
  json.extract! @trip, :id, :headsign, :direction
  json.route @trip.route, :id, :name
  json.stop_sequences @trip.stop_sequences.includes(:stop).ordered do |sequence|
    json.extract! sequence, :id, :sequence
    json.stop sequence.stop, :id, :name, :lat, :lon
   end
end



