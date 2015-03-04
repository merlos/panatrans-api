
module V1
  class RoutesControllerTest < ActionController::TestCase

    # Rails Routes
    test "should respond to route.index" do
        assert_routing '/v1/routes', { format: 'json', controller: "v1/routes", action: "index" }
    end
    
    test "should respond to route.with_trips" do
        assert_routing '/v1/routes/with_trips', { format: 'json', controller: "v1/routes", action: "with_trips" }
    end
        
    test "should respond to route.show" do
        assert_routing '/v1/routes/1', { format: 'json', controller: "v1/routes", action: "show", id: "1" }
    end
    
    
    # Functional 
    
    
    test "should get index" do
      xhr :get, :index
      assert_response :success
      assert_not_nil assigns(:routes)
    end
  
    test "should get list of routes with the trips linked to each route" do
      xhr :get, :with_trips
      assert_response :success
      assert_not_nil assigns(:routes)
    end
    
    test "should get a route" do
      r = routes(:albrook_miraflores)
      xhr :get, :show, {id: r.id}
      assert_response :success
      assert_not_nil assigns(:route)   
    end
    
    test "should create a route" do
      number_of_routes = Route.all.count
      
      xhr :post, :create, {route: {name: "Testing tin!"}}
      assert_response :success
      
      #puts response.body
      assert_not_nil assigns(:route)
      
      #check there is another route
      assert_equal number_of_routes + 1, Route.all.count
    end
    
    test "should not create a second route with same name" do
      route_name = "lalala"
      # we can create the first one
      xhr :post, :create, {route: {name: route_name}}
      assert_response :success
      assert_not_nil assigns(:route)
      # but not another one with the same name
      xhr :post, :create, {route: {name: route_name}}
      assert_response :unprocessable_entity
      #puts response.body
      assert_not_nil assigns(:route)
    end
    
    test "should update a route" do
      r = routes(:albrook_miraflores)
      new_name = "Testing ting ting"
      assert_not_equal new_name, r.name 
      xhr :patch, :update, {id: r.id, route: { name: new_name}}
      #verify db updated
      r2 = Route.find(r.id)
      assert_equal new_name, r2.name
    end
    
  end
end