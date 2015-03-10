require 'test_helper'

class StopSequenceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  
  def self.fill_model
    t = TripTest.fill_model
    s = StopTest.fill_model
    StopSequence.new(
    sequence: 10,
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
    assert @m.valid?
  end
  
  test 'trip is required' do
    @m.trip = nil
    assert @m.invalid?
  end
  
  test 'stop is required' do
    @m.stop = nil
    assert @m.invalid?
  end
  
  test 'sequence with negative number is valid' do
    @m.sequence = -1
    assert @m.valid?
  end
   
  test 'negative sequences add at the beginning of the list' do
    @m.sequence = -1
    @m.save!
    assert @m.in_list? 
    assert @m.first?
    assert_equal  1, @m.sequence
    
    # now we insert another one
    @m2 = StopSequence.new({sequence: -1, stop: @m.stop, trip: @m.trip})
    @m2.save!
    
    # get the sequences back from db
    @m_db = StopSequence.find(@m.id)
    @m2_db = StopSequence.find(@m2.id)
    
    # m2 should be the first
    # m should be the second 

    assert_equal 1, @m2_db.sequence
    assert_equal 2, @m_db.sequence
  end
  
  test 'if a 0 is provided then sequence is set as first' do
    @m.sequence = 0
    @m.save!
    assert @m.in_list? 
    assert @m.first?
    assert_equal  1, @m.sequence  
  end
 
  test 'stop_sequence without sequence inserts at the end' do
    @m.sequence = -1   
    @m2 = StopSequence.new({sequence: -1, stop: @m.stop, trip: @m.trip})
    @m2.save! 
    @m.save!
    
    #m2.sequence = 2
    #m.sequence = 1
    
    # now we add one stop_sequence without sequence
    @m3 = StopSequence.new({stop: @m.stop, trip: @m.trip})
    @m3.save!
    
    @m3_db = StopSequence.find(@m3.id)
    assert_equal 3, @m3_db.sequence
  end
 
  test 'insert sequence without number is last in list' do
    @m.save!
    @m2 = StopSequence.new({sequence: nil, stop: @m.stop, trip: @m.trip}) 
    assert_nil @m2.sequence
    @m2.save!
    assert_equal @m.sequence + 1, @m2.sequence
  end
    
  test 'sequence is increased if a stop_sequence is inserted with same value' do
    @test_sequence = 100
    
    # add 3 stop_sequences with same sequence number.
    @m.sequence = @test_sequence
    @m.save!
    @m2 = StopSequence.new({sequence: @test_sequence, stop: @m.stop, trip: @m.trip})
    @m2.save!
    @m3 = StopSequence.new({sequence: @test_sequence, stop: @m.stop, trip: @m.trip})
    @m3.save!
    
    #retrieve saved values
    @m_db = StopSequence.find(@m.id)
    @m2_db = StopSequence.find(@m2.id)
    @m3_db = StopSequence.find(@m3.id)
    
    assert_equal @test_sequence, @m3_db.sequence
    assert_equal @test_sequence + 1, @m2_db.sequence
    assert_equal @test_sequence + 2, @m_db.sequence
  end
  
  test 'sequence is not set if unknown_sequence is included' do
    @m.unknown_sequence = true
    @m.save!
    assert_nil @m.sequence
    @m_db = StopSequence.find(@m.id);
    assert_nil @m_db.sequence
  end
  
  
end
