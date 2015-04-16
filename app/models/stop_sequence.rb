# The MIT License (MIT)
# 
# Copyright (c) 2015 Juan M. Merlos, panatrans.org
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

class StopSequence < ActiveRecord::Base
  include Csvable
  
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
