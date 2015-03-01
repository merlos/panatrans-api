class StopSequence < ActiveRecord::Base
  
  scope :ordered, -> { order('sequence ASC') }
  
  # Validations
  validates :stop, presence: true
  validates :trip, presence: true
  validates :sequence, presence: true, numericality: { only_integer: true}
  
  
  # Associations
  belongs_to :trip
  belongs_to :stop
end
