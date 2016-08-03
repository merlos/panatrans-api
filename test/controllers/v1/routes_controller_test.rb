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

  class RoutesControllerTest < ActionController::TestCase

    def setup
      #
      # By default we assume tha we are NOT on a read_only_mode, that is
      # the API allows to modify the database
      # For tests of read only mode, read_only_mode will be set true
      #
      Rails.configuration.x.read_only_mode = false
    end

    # Rails Routes
    test "should respond to route.index" do
        assert_routing '/v1/routes', { format: 'json', controller: "v1/routes", action: "index" }
    end

    test "should respond to route.show" do
        assert_routing '/v1/routes/1', { format: 'json', controller: "v1/routes", action: "show", id: "1" }
    end


    # Functional


    test "should get index" do
      xhr :get, :index
      assert_response :success
      assert_not_nil assigns(:routes)
      assert_not assigns(:with_trips)
    end

    test "should get list of routes with the trips linked to each route" do
      xhr :get, :index, {with_trips: "true"}
      assert_response :success
      assert_not_nil assigns(:routes)
      assert assigns(:with_trips)
    end

    test "should get a route" do
      r = gtfs_api_routes(:route_one)
      xhr :get, :show, {id: r.id}
      assert_response :success
      assert_not_nil assigns(:route)
    end

    #
    # TODO - Create, edit and delete routes
    #
    #test "should create a route" do
    #  number_of_routes = GtfsApi::Route.all.count
    #   xhr :post, :create, {route: {name: "Testing tin!"}}
    #  assert_response :success
    #
    #  #puts response.body
    #  assert_not_nil assigns(:route)
    #  #check there is another route
    #  assert_equal number_of_routes + 1, GtfsApi::Route.all.count
    #end

    #test "should not create a second route with same name" do
    #  route_name = "lalala"
    # we can create the first one
    #  xhr :post, :create, {route: {name: route_name}}
    # assert_response :success
    #  assert_not_nil assigns(:route)
    #  # but not another one with the same name
    #  xhr :post, :create, {route: {name: route_name}}
    #  assert_response :unprocessable_entity
    #  #puts response.body
    #  assert_not_nil assigns(:route)
    #end

    #test "should update a route" do
    #  r = gtfs_api_routes(:route_one)
    #  new_name = "Testing ting ting"
    #  assert_not_equal new_name, r.name
    #  xhr :patch, :update, {id: r.id, route: { name: new_name}}
    #  #verify db updated
    #  r2 = GtfsApi::Route.find(r.id)
    #  assert_equal new_name, r2.name
    #end

    #test "should delete a route" do
    #  r = gtfs_api_routes(:route_one);
    #  xhr :delete, :destroy, {id: r.id}
    #  assert_response :success
    #
    #  # now check that it was certainly removed
    #  assert_raise (ActiveRecord::RecordNotFound) {
    #    r2 = GtfsApi::Route.find(r.id)
    #  }
    #  #assert_response :not_found # ----- TODO ??
    #end

    #test "should throw error if try to delete an inexistent resource" do
    #  assert_raise (ActiveRecord::RecordNotFound) {
    #    xhr :delete, :destroy, {id: 123456789}
    #  }
    #  #assert_response :not_found # ----- TODO ??
    #end


    #######
    # TESTS to check READ ONLY MODE
    #######
    #test "should NOT create a route if read only mode" do
    #  Rails.configuration.x.read_only_mode = true
    #  number_of_routes = GtfsApi::Route.all.count
    #  xhr :post, :create, {route: {name: "Testing tin!"}}
    #  assert_response :forbidden
    #
    #  #check there is another route
    #  assert_equal number_of_routes, GtfsApi::Route.all.count
    #end
    #
    #test "should NOT update a route if read_oly_mode" do
    #  Rails.configuration.x.read_only_mode = true
    #  r = gtfs_api_routes(:route_one)
    #  new_name = "Testing ting ting"
    #  assert_not_equal new_name, r.name
    #  xhr :patch, :update, {id: r.id, route: { name: new_name}}
    #  assert_response :forbidden
    #  #verify db updated
    #  r2 = GtfsApi::Route.find(r.id)
    #  assert_not_equal new_name, r2.name
    #end

    #test "should NOT delete a route if read_only_mode" do
    #  Rails.configuration.x.read_only_mode = true
    #  r = gtfs_api_routes(:route_one)
    #  xhr :delete, :destroy, {id: r.id}
    #  assert_response :forbidden
    #  assert GtfsApi::Route.find(r.id)
    #end
  end
end
