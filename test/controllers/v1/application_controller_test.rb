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

module V1  
  class TestableController < ApplicationController
    def index
      render :text => 'rendered content here', :status => 200
    end
  end
  
  class ApplicationControllerTest < ActionController::TestCase
    tests TestableController
    
    setup do
      # create a fake route for tests
      Rails.application.routes.append do
        namespace :v1 do
            get '/v1/testable/' => "testable#index"
            get '/v1/testable/since/:seconds_since_epoc' => "testable#since"
        end
      end
      Rails.application.reload_routes!
      
      #
      # Debug snippet to verify that the route was added
      #
      #Rails.application.routes.routes.each do |route|
      #  route = route.path.spec.to_s
      #  puts route
      #end
    end
    
    # routes
    test "since route is not valid for any resource, only models" do
      assert_raise(ActionController::UrlGenerationError) {
        get '/v1/balance/since/0'
      }  
      assert_routing '/v1/routes/since/0', { format: 'json', controller: "v1/routes", action: "since", seconds_since_epoc: "0"}
      assert_routing '/v1/stops/since/0', { format: 'json', controller: "v1/stops", action: "since", seconds_since_epoc: "0" }
    end
    
    test "since route works with csv format" do
        assert_routing '/v1/routes/since/0.csv', { format: 'csv', controller: "v1/routes", action: "since", seconds_since_epoc: "0" }
    end
    
    
    # before_filter default response data
    
    test "should set success as default data" do
      xhr :get, :index
      assert_equal ApplicationController::Status[:success], assigns(:status)
    end
    
    test "should not enable prettify output as default" do
      xhr :get, :index
      assert_not assigns(:prettify)
    end

    test "should activate prettify output with prettify param set to one" do
      xhr :get, :index, {prettify: 1}
      assert assigns(:prettify)
    end
    
    test "should activate prettify output if pretty param set to string true" do
      xhr :get, :index, {prettify: "true"}
      assert assigns(:prettify)
    end
 

    test "since should not assign results" do
      xhr :get, :since, {seconds_since_epoc: "0"}
      assert_response :not_found
    end
  end # class
  
  # To test since method works we need a real resource
  class ApplicationControllerSinceTest < ActionController::TestCase
    tests RoutesController
    
    test "since should assign results" do
      xhr :get, :since, {seconds_since_epoc: "0"}
      assert_response :success
      assert_not_nil assigns(:results)
    end
  end # class
    
  
end #module