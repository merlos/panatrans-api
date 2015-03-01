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
  
end
