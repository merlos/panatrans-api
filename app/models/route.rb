class Route < ActiveRecord::Base
  
  # Validations
  validates :name, presence: true, uniqueness: true, length: { minimum: 5}
  
  # Associations
  has_many :trips
  
  
end
