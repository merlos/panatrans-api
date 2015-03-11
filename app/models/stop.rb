class Stop < ActiveRecord::Base
  include Csvable
    
  # Validations
  validates :lat, presence: true, numericality: { greater_than: -90.000000, less_than: 90.000000}
  validates :lon, presence: true, numericality: {greater_than: -180.000000, less_than: 180.000000}
  
  
  # Associations
  has_many :stop_sequences
  has_many :trips, through: :stop_sequences 
  
  def routes
    Route.joins(trips: :stops).distinct.where(stops: {id: self.id}).order('name ASC')
  end
  
  
  
end
