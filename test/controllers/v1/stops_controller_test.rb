
module V1
  class StopsControllerTest < ActionController::TestCase

    # Rails Routes
    
    test "should respond to stop.show" do
        assert_routing '/v1/stops/1', { format: 'json', controller: "v1/stops", action: "show", id: "1" }
    end
    
    test "should respond to stop.index" do
        assert_routing '/v1/stops', { format: 'json', controller: "v1/stops", action: "index" }
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
    
  end
end