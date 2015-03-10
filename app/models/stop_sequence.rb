class StopSequence < ActiveRecord::Base
  
  scope :ordered, -> { order('sequence ASC') }
  acts_as_list column: :sequence, scope: :trip
  
  
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
  
  def unknown_sequence=(val)
    @unkown_sequence = (val == true)
  end
  
  # by default when sequence is not set acts_as_list saves the record
  # at the end of the list (this is done before validation) For those stops with unknown sequence 
  # we need to avoid this behaviour.
  def check_if_unknown_sequence
    if (self.unknown_sequence == true)
      self.sequence = nil
    end
    #puts attributes
  end
  

  # Associations

  belongs_to :trip
  belongs_to :stop
  
end
