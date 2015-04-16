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

module V1
  class StopsControllerTest < ActionController::TestCase

    # Rails Routes
    
    test "should respond to stop.show" do
        assert_routing '/v1/stops/1', { format: 'json', controller: "v1/stops", action: "show", id: "1" }
    end
    
    test "should respond to stop.index" do
        assert_routing '/v1/stops', { format: 'json', controller: "v1/stops", action: "index" }
    end
    
    test "should respond to stops nearby route" do
        assert_routing '/v1/stops/nearby', {format: 'json', controller: 'v1/stops', action: 'nearby'}
    end
    
    test "should get stops in gpx format" do
        assert_routing '/v1/stops.gpx', { format: 'gpx', controller: "v1/stops", action: "index"}
    end
  
    test "should get stops in kml format" do
        assert_routing '/v1/stops.kml', { format: 'kml', controller: "v1/stops", action: "index"}
    end
  
    
    # Functional 
    
    
    test "should get index" do
      xhr :get, :index
      assert_response :success
      assert_not_nil assigns(:stops)
    end
  
    test "should get a stop" do
      @s = stops(:albrook)
      xhr :get, :show, {id: @s.id}
      assert_response :success
      assert_not_nil assigns(:stop)
      assert_not assigns(:with_stop_sequences)
    end
    
    test "should create a stop" do
      number_of_stops = Stop.all.count
      xhr :post, :create, {stop: {name: "Testing tin!", lat: 3.1, lon: 40.0}}
      assert_response :success
      #puts response.body
      assert_not_nil assigns(:stop)
      #also check there is another stop
      assert_equal number_of_stops + 1, Stop.all.count
    end
    
    test "should be able to create a second stop with same name" do
      stop_name = "lalala"
      # we can create the first one
      xhr :post, :create, {stop: {name: stop_name, lat: 3.1, lon: 40.0}}
      assert_response :success
      assert_not_nil assigns(:stop)
      # but not another one with the same name
      xhr :post, :create, {stop: {name: stop_name, lat: 3.1, lon: 40.0}}
      assert_response :success
      #puts response.body
      assert_not_nil assigns(:stop)
    end
    
    test "should update a stop" do
      @s = stops(:albrook)
      new_name = "Testing ting ting"
      assert_not_equal new_name, @s.name 
      xhr :patch, :update, {id: @s.id, stop: { name: new_name}}
      #verify db updated
      @s2 = Stop.find(@s.id)
      assert_equal new_name, @s2.name
    end
    
    test "should return nearby stops" do
      @s = stops(:albrook)
      xhr :get, :nearby, {lat: @s.lat, lon: @s.lon, radius: 1000}
      assert_response :success
      assert_not_nil assigns(:stops)
    end
    
    test "should support with_stop_sequences option" do
      @s = stops(:albrook)
      xhr :get, :show, {id: @s.id, with_stop_sequences: "true"}
      assert_response :success
      assert_not_nil assigns(:stop)
      assert assigns(:with_stop_sequences)
    end
    
    
    test "get all stops in gpx format returns the correct content type" do
      get :index, {format: 'gpx'}
      assert_response :success
      # check content type
      assert_equal :gpx, Mime::Type.lookup(@response.content_type).to_sym
    end
    
    test "get all stops in kml format returns the correct content type" do
      get :index, {format: 'kml'}
      assert_response :success
      # check content type
      assert_equal :kml, Mime::Type.lookup(@response.content_type).to_sym
    end
    
  end
end