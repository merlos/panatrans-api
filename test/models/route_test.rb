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
  
  test "trips are created when saving the route" do
    @m.save!
    assert_equal 0, @m.trips.count
    t0 = TripTest.fill_model
    t1 = TripTest.fill_model
    t0.route = @m
    t1.route = @m
    @m.trips = [t0, t1]
    @m.save!
    
    @m2 = Route.find(@m.id)
    assert 2, @m2.trips.count 
  end
   
  test "trips with errors cannot be added to a route" do
    @m.save!
    assert_equal 0, @m.trips.count
    t0 = TripTest.fill_model
    t1 = TripTest.fill_model
    t0.route = @m
    t1.route = @m
    t1.direction = -200 # will throw error
    
    assert_raises(ActiveRecord::RecordNotSaved) {
      @m.trips = [t0, t1]      
    }
    @m2 = Route.find(@m.id)
    assert 0, @m2.trips.count  
  end

  
end
