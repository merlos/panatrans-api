
module V1
  class StopSequencesControllerTest < ActionController::TestCase

    # Rails Routes
    
    test "should respond to stop_sequence.show" do
        assert_routing '/v1/stop_sequences/1', { format: 'json', controller: "v1/stop_sequences", action: "show", id: "1" }
    end
    
    test "should respond to stop_sequence.index" do
        assert_routing '/v1/stop_sequences', { format: 'json', controller: "v1/stop_sequences", action: "index" }
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
    
    test "should update a stop_sequence" do
      @s = stop_sequences(:alb_mir_1)
      new_sequence = 10
      assert_not_equal new_sequence, @s.sequence 
      xhr :patch, :update, {id: @s.id, stop_sequence: { sequence: new_sequence}}
      #verify db updated
      @s2 = StopSequence.find(@s.id)
      assert_equal new_sequence, @s2.sequence
    end
    
  end
end