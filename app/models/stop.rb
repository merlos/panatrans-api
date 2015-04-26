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

class Stop < ActiveRecord::Base
  include Csvable
  
  scope :ordered, -> { order('name ASC') }
    
  # Validations
  validates :lat, presence: true, numericality: { greater_than: -90.000000, less_than: 90.000000}
  validates :lon, presence: true, numericality: {greater_than: -180.000000, less_than: 180.000000}
  
  
  # Associations
  has_many :stop_sequences
  has_many :trips, -> { uniq }, through: :stop_sequences
  
  def routes
    Route.joins(trips: :stops).distinct.where(stops: {id: self.id}).order('name ASC')
  end
  
  #
  # stops nearby the center of a position.
  # receives 3 params :lat, :lon, :radius
  #
  # BTW, it searchs within a square (efficiency)
  #
  def self.nearby (params)
    lat, lon, radius = params.values_at :lat, :lon, :radius
    # Not exact but easy. consider Earth a perfect sphere with a radius of 6371km
    # http://en.wikipedia.org/wiki/Longitude#Length_of_a_degree_of_longitude
    # http://en.wikipedia.org/wiki/Latitude#Meridian_distance_on_the_sphere
    #
    radius_lat = radius.to_f / 111194.9
    radius_lon = (radius.to_f / 111194.9) * Math::cos(lat.to_f).abs 
  
    max_lat = lat.to_f + radius_lat
    min_lat = lat.to_f - radius_lat
    
    max_lon = lon.to_f + radius_lon
    min_lon = lon.to_f - radius_lon
    #Stop.where("lat > ? AND lat < ? AND lon > ? AND lon < ? ", min_lat, max_lat, min_lon, max_lon) 
    Stop.where(lat: min_lat..max_lat, lon: min_lon..max_lon) 
  end
  
  # export to Google Earth KML
  def self.to_kml 
    kml = KMLFile.new
    folder = KML::Folder.new(name: 'Panatrans')
    all.each do |stop|
      folder.features << KML::Placemark.new(
          :name => stop.name,
        :geometry => KML::Point.new(coordinates: { lat: stop.lat, lng: stop.lon})
      )
    end
    kml.objects << folder
    kml.render    
  end
  
  # export to gpx
  def self.to_gpx
    require 'GPX'
    gpx = GPX::GPXFile.new(name: 'Panatrans')  
    all.each do |stop|
      gpx.waypoints << GPX::Waypoint.new({name: stop.name, lat: stop.lat, lon: stop.lon, time: stop.updated_at})
    end     
    gpx.to_s
  end
  
  # Distance from stop to point (straight line)
  # Example:
  #  @stop = stop.new({name: "name", lat: 0.0, lon: 1.1})
  #  @stop.distance_to(1.1, 2.2)
  #        => 172973.39717474958 
  def distance_to(lat, lon)
    Haversine.distance(self.lat, self.lon, lat, lon).to_meters
  end
end
