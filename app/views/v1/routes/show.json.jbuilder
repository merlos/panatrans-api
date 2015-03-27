json.prettify! if @prettify
json.status @status
json.data do
  json.extract! @route, :id, :name, :url
  json.trips @route.trips.includes(:stop_sequences) do |trip|
    json.extract! trip, :id, :headsign, :direction
    json.stop_sequences trip.stop_sequences.includes(:stop).ordered do |sequence|
      json.id sequence.id
      json.sequence sequence.sequence
      json.stop sequence.stop, :id, :name, :lat, :lon
     end
  end
end
  


