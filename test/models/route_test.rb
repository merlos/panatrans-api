require 'test_helper'

class RouteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def self.fill_model
    Route.new(
      name: "route" + random
    )
  end
  
  def setup 
    @m = RouteTest.fill_model 
  end
  
  test "valid model" do
    assert @m.valid?
  end
  
  test "route name presence is required" do
    @m.name = nil
    assert @m.invalid?
  end
  
  test 'route name uniqueness' do
    @m.save!
    @m2 = RouteTest.fill_model
    @m2.name = @m.name
    assert @m2.invalid?
  end
  
  
end
