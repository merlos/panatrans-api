# The MIT License (MIT)
# 
# Copyright (c) 2015 Juan M. Merlos, panatrans.org
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

json.prettify! if @prettify
json.status @status
json.data do
  json.extract! @stop, :id, :name, :lat, :lon
  json.routes @stop.routes do |route| 
    json.extract! route, :id, :name, :url
    # ONLY if with_stop_sequences is set => get the trips with the stop_sequences 
    json.trips (@with_stop_sequences ? @stop.trips.includes(:stop_sequences) : @stop.trips) do |trip|
      if trip.route_id == route.id
        json.extract! trip, :id, :headsign, :direction, :route_id
        if @with_stop_sequences
          json.stop_sequences trip.stop_sequences do |stop_sequence|
            json.extract! stop_sequence, :id, :sequence, :stop_id, :trip_id
          end
        end
      end
    end # trip
  end # route
end # data
  


