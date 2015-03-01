json.status @status
json.data do
  json.extract! @route, :id, :name
  json.trips @route.trips.includes(:stop_sequences) do |trip|
    json.extract! trip, :id, :headsign, :direction
    json.stops trip.stop_sequences.includes(:stop).ordered do |sequence|
      json.sequence sequence.sequence
      json.extract! sequence.stop, :id, :name, :lat, :lon
     end
  end
end
  


