class StopSequence < ActiveRecord::Base
  include Csvable
  has_paper_trail  
  
  scope :ordered, -> { order('sequence ASC') }
  acts_as_list column: :sequence, scope: :trip, top_of_list: 0
  
  
  # Validations
  
  validates :stop, presence: true
  validates :trip, presence: true
  validates :sequence, allow_nil: true, numericality: { only_integer: true}
  
  before_create :check_if_unknown_sequence
  before_save :check_if_unknown_sequence
  
  #Virtual Attributes
  
  attr_accessor :unknown_sequence #if set, then the sequence is unknown
  
  def unknown_sequence
    @unkown_sequence
  end
  
  # whenever unknown_sequence is set to true, sequence is set to nil 
  # sequence = nil means that the sequence within the list is unknown)
  def unknown_sequence=(val)
    @unkown_sequence = (val == true)
  end
  
  # by default when sequence is not set acts_as_list saves the record
  # at the end of the list (the sequence  is set before_validation) For those stops with unknown sequence 
  # we need to avoid this behaviour.
  def check_if_unknown_sequence
    self.sequence = nil if self.unknown_sequence
  end
  

  # Associations

  belongs_to :trip
  belongs_to :stop
  
end
