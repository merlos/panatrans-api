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

class StopTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def self.fill_model
    Stop.new(
      name: "Stop" + random,
      lat: 3.33,
      lon: 4.44
    )
  end
  
  def setup 
    @m = StopTest.fill_model 
  end
  
  
  # Test Validations 
  
  
  test "valid model" do
    assert @m.valid?
  end
  
  test 'lat is required' do
    @m.lat = nil
    assert @m.invalid?
  end
  
  test 'lon is required' do
    @m.lon = nil
    assert @m.invalid?
  end
  
  test "lat range is between -90 and 90" do
    @m.lat =  -90.10
    assert @m.invalid?
    
    @m2 = StopTest.fill_model
    @m2.lat = 90.10
    assert @m2.invalid?
  end
  
  test 'lon range is between -180 and 180' do
    @m.lon =  -180.10
    assert @m.invalid?
    
    @m2 = StopTest.fill_model
    @m2.lon = 180.10
    assert @m2.invalid?
  end
    
    
  # Test Methods 
  
  
  test "find routes for stop" do
   
    # create some routes
   r1 = RouteTest.fill_model
   r1.save!
   r2 = RouteTest.fill_model
   r2.save!
   r3 = RouteTest.fill_model
   r3.save!
   r4 = RouteTest.fill_model
   r4.save!
   # create two trips. One for r1 and one for r2
   t1 = TripTest.fill_model
   t1.route = r1
   t1.save!
   t2 = TripTest.fill_model
   t2.route = r2
   t2.save!
   # Save the stop
   @m.save!
   # Assign to t1 trip => stop @m and to t2 stop @m
   ss1 = StopSequence.new( sequence: 1, stop: @m, trip: t1)
   ss1.save!
   ss2 = StopSequence.new( sequence: 1, stop: @m , trip: t2)
   ss2.save!
   # This stop has two routes linked to it
   stop_routes = @m.routes
   
   # to review SQL
   #ActiveRecord::Base.logger = Logger.new(STDOUT)
   #puts @m.routes.inspect
   #ActiveRecord::Base.logger = nil
   
   # routes are returned by name asc, then
   assert_equal r1, stop_routes[0]
   assert_equal r2, stop_routes[1]
  end
  
  test "nearby finds stops" do
    params = { lat: "0.00", lon: "0.00", radius: "1000"} # 1000 m ~ 0.1 degrees
    #there are stops on the db
    assert_not_equal 0, Stop.all.count
    #but not on the radius
    assert_equal 0, Stop.nearby(params).count
    
    #add 1 stop within the radius
    @s = Stop.new({name: "holitas", lat: "0.001", lon: "0.001"});
    @s.save!
    assert_equal 1, Stop.nearby(params).count
    # add another stop within the radius and check it finds
    @s2 = Stop.new({name: "vecinito", lat: "0.001", lon: "0.001"});
    @s2.save!
    # Stop.nearby(params).each do |s|
    #   puts s.inspect
    # end
    assert_equal 2, Stop.nearby(params).count
  end
  
  
  
  test "distance_to returns the distance" do
    @s = Stop.new({name: "cero", lat: 0.0, lon: 0.0})
    # check that are almost the same (the order of the arguments affects the results)
    assert_in_delta Haversine.distance(0.0, 0.0, 1.1, 1.1).to_meters, @s.distance_to(1.1, 1.1), 0.000001
  end
  
end
