class Route < ActiveRecord::Base
  include Csvable
  
  # Validations
  validates :name, presence: true, uniqueness: true, length: { minimum: 5}
  validates :url, format: { with: URI.regexp }, allow_nil: true
  # Associations
  has_many :trips
  
  
end
