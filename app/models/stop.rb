class Stop < ActiveRecord::Base
  include Csvable
  has_paper_trail  
    
  # Validations
  validates :lat, presence: true, numericality: { greater_than: -90.000000, less_than: 90.000000}
  validates :lon, presence: true, numericality: {greater_than: -180.000000, less_than: 180.000000}
  
  
  # Associations
  has_many :stop_sequences
  has_many :trips, through: :stop_sequences 
  
  # routes that have this stop in their trips.
  def routes
    Route.joins(trips: :stops).distinct.where(stops: {id: self.id}).order('name ASC')
  end
  
  #
  # stops nearby the center of a position.
  # receives 3 params :lat, :lon, :radius
  #
  # BTW, it searchs within a square
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
  
  # Distance from stop to point (straight line) in meters
  # Example:
  #  @stop = stop.new({name: "name", lat: 0.0, lon: 1.1})
  #  @stop.distance_to(1.1, 2.2)
  #        => 172973.39717474958 
  def distance_to(lat, lon)
    Haversine.distance(self.lat, self.lon, lat, lon).to_meters
  end
end
