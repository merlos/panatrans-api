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
  class StopSequencesControllerTest < ActionController::TestCase


    # Rails Routes
    
    test "should respond to stop_sequence.show" do
        assert_routing '/v1/stop_sequences/1', { format: 'json', controller: "v1/stop_sequences", action: "show", id: "1" }
    end
    
    
    test "should respond to stop_sequence.index" do
        assert_routing '/v1/stop_sequences', { format: 'json', controller: "v1/stop_sequences", action: "index" }
    end
    
    
    test "should respond to delete by trip and stop ids" do
      assert_routing( {
        method: :delete,
        path: '/v1/stop_sequences/trip/1/stop/2'
        }, {
          format:'json',
          controller: 'v1/stop_sequences',
          action: "destroy_by_trip_and_stop", 
          trip_id: "1", 
          stop_id: "2"
          }
      )
    end
    
    
    # Functional 
    
    test "should get index" do
      xhr :get, :index
      assert_response :success
      assert_not_nil assigns(:stop_sequences)
    end

  
    test "should get a stop_sequence" do
      @s = stop_sequences(:alb_mir_1)
      xhr :get, :show, {id: @s.id}
      assert_response :success
      assert_not_nil assigns(:stop_sequence)
    end

    
    test "should create a stop_sequence" do
      number_of_stop_sequences = StopSequence.all.count
      @trip = routes(:albrook_miraflores)
      @stop = stops(:albrook)
      xhr :post, :create, {stop_sequence: {sequence: 10, stop_id: @stop.id, trip_id: @trip.id}}
      assert_response :success
      #puts response.body
      assert_not_nil assigns(:stop_sequence)
      #also check there is another stop_sequence
      assert_equal number_of_stop_sequences + 1, StopSequence.all.count
    end
   
    
    test "should be able to create a second stop_sequence with same sequence" do
      sequence = 1
      # we can create the first one
      @trip = routes(:albrook_miraflores)
      @stop = stops(:albrook)
      xhr :post, :create, {stop_sequence: {sequence: 10, stop_id: @stop.id, trip_id: @trip.id}}
      assert_response :success
      assert_not_nil assigns(:stop_sequence)
      # but not another one with the same name
      xhr :post, :create, {stop_sequence: {sequence: 10, stop_id: @stop.id, trip_id: @trip.id}}
      #puts response.body
      assert_response :success
      assert_not_nil assigns(:stop_sequence)
    end
   
    
    test "should be able to create a stop_sequence with negative value" do
      @trip = routes(:albrook_miraflores)
      @stop = stops(:albrook)
      @sequence = -1
      xhr :post, :create, {stop_sequence: {sequence: @sequence , stop_id: @stop.id, trip_id: @trip.id}}
      assert_response :success
      assert_not_nil assigns(:stop_sequence)
    end
  
  
    test "should update a stop_sequence" do
      @s = stop_sequences(:alb_mir_1)
      new_sequence = 10
      assert_not_equal new_sequence, @s.sequence 
      xhr :patch, :update, {id: @s.id, stop_sequence: { sequence: new_sequence}}
      assert_response :success
      #verify db updated
      @s2 = StopSequence.find(@s.id)
      assert_equal new_sequence, @s2.sequence
    end
    
    
    test "should delete a stop_sequence providing the id" do
      @s = stop_sequences(:alb_mir_1)
      @count = StopSequence.all.count
      xhr :delete, :destroy, {id: @s.id}
      assert_response :success
      assert_raises (ActiveRecord::RecordNotFound) {
        @s2 = StopSequence.find(@s.id)
      }
      assert_equal @count-1, StopSequence.all.count
    end
  
    
    test "should delete a stop_sequence with trip and stop ids" do
      @s = stop_sequences(:alb_mir_1)
      @count = StopSequence.all.count
      xhr :delete, :destroy_by_trip_and_stop, {stop_id: @s.stop_id, trip_id: @s.trip_id}
      assert_response :success
      assert_raises (ActiveRecord::RecordNotFound) {
        @s2 = StopSequence.find(@s.id)
      }
      assert_equal @count-1, StopSequence.all.count
    end
    
    
  end
end