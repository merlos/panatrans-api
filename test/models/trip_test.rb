require 'test_helper'

class TripTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  
  def self.fill_model
    r = RouteTest.fill_model
    r.save!
    
    Trip.new(
      headsign: "Trip " + random,
      direction: 0,
      route: r
    )
  end
  
  def setup 
    @m = TripTest.fill_model 
  end
  
  test "valid model" do
    assert @m.valid?
  end
  
  test 'headsign is required' do
    @m.headsign = nil
    assert @m.invalid?
  end
  
  test 'route is required' do
    @m.route = nil
    assert @m.invalid?
  end
  
  test 'direction can be nil' do
    @m.direction = nil
    assert @m.valid?
  end
  
  test 'direction cannot be negative' do
    @m.direction = -1
    assert @m.invalid?
  end
  
  test 'direction cannot be greater than 1' do
    @m.direction = 2
    assert @m.invalid?
  end
  
  test 'stop_sequences are ordered by stop_sequence sequence in ascendent order' do
    #we need to add some stop sequences to this
    @m.save!
    
    
    @ss0 = StopSequenceTest.fill_model
    @ss0.sequence = 0
    @ss0.trip = @m
    
    
    @ss1 = StopSequenceTest.fill_model
    @ss1.sequence = 1
    @ss1.trip = @m
    
    
    @ss_nil = StopSequenceTest.fill_model
    @ss_nil.sequence = nil
    @ss_nil.unknown_sequence = true
    @ss_nil.trip = @m 
    
    @ss1.save!
    @ss_nil.save!
    @ss0.save!
    
    #puts @ss1.inspect
    #puts @ss0.inspect
    #puts @ss_nil.inspect
    
    assert_equal 3, @m.stop_sequences.count
    assert_equal @ss_nil.id, @m.stop_sequences[0].id
    assert_equal @ss0.id, @m.stop_sequences[1].id
    assert_equal @ss1.id, @m.stop_sequences[2].id
    # this is not a very strong test as randomly this could be the result... think something better
    
  end
  
end
