json.prettify! if @prettify
json.status @status
json.data @stops, :id, :name, :lat, :lon

