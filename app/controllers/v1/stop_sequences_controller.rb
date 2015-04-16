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
  class StopSequencesController < ApplicationController
    before_action :set_stop_sequence, only: [:show, :update, :destroy]
    
    def index 
      @stop_sequences = StopSequence.all
    end
      
    def show
    end 
        
    def create
      @stop_sequence = StopSequence.new(stop_sequence_params)
      
      if @stop_sequence.save 
        render :show, status: :created, location: v1_stop_sequence_path(@stop_sequence)
      else
       render_json_fail(:unprocessable_entity, @stop_sequence.errors)
      end
    end
      
    def update
      # BUG of act_as_list
      # if an element is not in list and added to the list => there is a weird behaviour with the
      # first position 
      # current element in position 0, keeps the same position.
      # HACK: first add to the list => on the last position
      #
      if @stop_sequence.not_in_list? && (stop_sequence_params[:sequence] != nil) && !stop_sequence_params[:unknown_sequence]
        @stop_sequence.insert_at(10000000)
      end
      
      if @stop_sequence.in_list? && (stop_sequence_params[:unknown_sequence])
        @stop_sequence.remove_from_list
      end
      
      if @stop_sequence.update(stop_sequence_params)
        render :show, status: :ok, location: v1_stop_sequence_path(@stop_sequence) 
      else
        render_json_fail(:unprocessable_entity, @stop_sequence.errors)  
      end
    end 
    
    def destroy
      @stop_sequence.destroy
      head :no_content 
    end
     
    def destroy_by_trip_and_stop
      @stop_sequence = StopSequence.find_by(stop_id: params[:stop_id], trip_id: params[:trip_id])
      @stop_sequence.destroy
      head :no_content
    end 
     
    private
   
      # Use callbacks to share common setup or constraints between actions.
      def set_stop_sequence
        @stop_sequence = StopSequence.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def stop_sequence_params
        params.require(:stop_sequence).permit(:sequence, :stop_id, :trip_id, :unknown_sequence)
      end
  end
end