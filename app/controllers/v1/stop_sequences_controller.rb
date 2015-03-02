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
     
    private
    
      # Use callbacks to share common setup or constraints between actions.
      def set_stop_sequence
        @stop_sequence = StopSequence.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def stop_sequence_params
        params.require(:stop_sequence).permit(:sequence, :stop_id, :trip_id)
      end
      
  end
end