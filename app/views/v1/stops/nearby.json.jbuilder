json.status @status
json.data @stops do |stop|
  json.extract! stop, :id, :name, :lat, :lon
  json.distance number_with_precision(stop.distance_to(@lat, @lon), precision:0)
end