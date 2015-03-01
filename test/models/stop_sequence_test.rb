require 'test_helper'

class StopSequenceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  
  def self.fill_model
    t = TripTest.fill_model
    s = StopTest.fill_model
    StopSequence.new(
    sequence: 1,
    trip: t,
    stop: s
    )
  end
  
  def setup 
    @m = StopSequenceTest.fill_model 
  end


  # Test Validations


  test "valid model" do
    assert @m.valid?
  end
  
  test 'sequence is required' do
    @m.sequence = nil
    assert @m.invalid?
  end
  
  test 'trip is required' do
    @m.trip = nil
    assert @m.invalid?
  end
  
  test 'stop is required' do
    @m.stop = nil
    assert @m.invalid?
  end
  
  
end
