class Route < ActiveRecord::Base
  include Csvable
  
  # Validations
  validates :name, presence: true, uniqueness: true, length: { minimum: 5}
  
  # Associations
  has_many :trips
  
  
end
