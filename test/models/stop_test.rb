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
  
  
end
