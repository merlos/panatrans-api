require 'test_helper'

class RouteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def self.fill_model
    Route.new(
      name: "route" + random,
      url: "http://www.site.com/"
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
  
  test 'empty route url' do
    @m.url = nil
    assert @m.valid?
  end
  
  test 'route url invalid' do
    @m.url ="8192741982734"
    assert @m.invalid?
  end
  
  
  test 'route url https' do
    @m.url = "https://www.panatrans.org"
    assert @m.valid?
  end
  
end
