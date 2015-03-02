
module V1
  class TripsControllerTest < ActionController::TestCase

    # Rails Routes
    
    test "should respond to trip.show" do
        assert_routing '/v1/trips/1', { format: 'json', controller: "v1/trips", action: "show", id: "1" }
    end
    
    test "should respond to trip.index" do
        assert_routing '/v1/trips', { format: 'json', controller: "v1/trips", action: "index" }
    end
    
    
    # Functional 
    
    
    test "should get index" do
      xhr :get, :index
      assert_response :success
      assert_not_nil assigns(:trips)
    end
  
    test "should get a trip" do
      @s = trips(:albrook_miraflores)
      xhr :get, :show, {id: @s.id}
      assert_response :success
      assert_not_nil assigns(:trip)
    end
    
    test "should create a trip" do
      number_of_trips = Trip.all.count
      route = routes(:albrook_miraflores)
      xhr :post, :create, {trip: {headsign: "Testing tin!", direction: 1, route_id: route.id}}
      assert_response :success
      #puts response.body
      assert_not_nil assigns(:trip)
      #also check there is another trip
      assert_equal number_of_trips + 1, Trip.all.count
    end
    
    test "should be able to create a second trip with same name" do
      trip_name = "lalala"
      # we can create the first one
      route = routes(:albrook_miraflores)
      xhr :post, :create, {trip: {headsign: trip_name, direction: 1, route_id: route.id}}
      assert_response :success
      assert_not_nil assigns(:trip)
      # but not another one with the same name
      xhr :post, :create, {trip: {headsign: trip_name, direction: 1, route_id: route.id}}
      assert_response :success
      #puts response.body
      assert_not_nil assigns(:trip)
    end
    
    test "should update a trip" do
      @s = trips(:albrook_miraflores)
      new_headsign = "Testing ting ting"
      assert_not_equal new_headsign, @s.headsign 
      xhr :patch, :update, {id: @s.id, trip: { headsign: new_headsign}}
      #verify db updated
      @s2 = Trip.find(@s.id)
      assert_equal new_headsign, @s2.headsign
    end
    
  end
end