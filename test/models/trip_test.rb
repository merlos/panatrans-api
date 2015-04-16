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
  
  
  test 'save multiple trips in a single create' do 
    trips = [
      { headsign: "one", direction: 0, route_id: @m.route.id},
      { headsign: "two", direction: 1, route_id: @m.route.id}
    ]
    t = Trip.create(trips)
    t.each do |trip|
      assert trip.valid?
    end
  end
  
  
  test 'save multiple trips in a single create but with errors' do 
    trips = [
      { headsign: "one", direction: 0, route_id: @m.route.id},
      { headsign: "two", direction: 1} # no route
    ]
    t = Trip.create(trips)
    assert t[0].valid?
    assert t[1].invalid?
    
  end
  
  
end
