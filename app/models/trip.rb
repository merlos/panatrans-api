class Trip < ActiveRecord::Base
  include Csvable
  has_paper_trail  
  
  # Validations 
  validates :route, presence: true
  validates :headsign, presence: true
  validates :direction, allow_nil: true, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1}

    
  # Associations
  belongs_to :route
  has_many :stop_sequences 
  has_many :stops, through: :stop_sequences


end
