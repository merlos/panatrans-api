class Route < ActiveRecord::Base
  include Csvable
  has_paper_trail  
  
  # Validations
  validates :name, presence: true, uniqueness: true, length: { minimum: 5}
  
  # Associations
  has_many :trips
  
  
end
