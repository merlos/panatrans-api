module V1
  class StopsController < ApplicationController
    
    before_action :set_stop, only: [:show, :update, :destroy]

    
    def index 
      @stops = Stop.all.order('name ASC')
    end


    def show
    end

    
    def create
      @stop = Stop.new(stop_params)
      if @stop.save
        render :show, status: :created, location: v1_stop_path(@stop)
      else
       render_json_fail(:unprocessable_entity, @stop.errors)
      end
    end

    
    def update
      if @stop.update(stop_params)
        render :show, status: :ok, location: v1_stop_path(@stop) 
      else
        render_json_fail(:unprocessable_entity, @stop.errors)  
      end
    end
  
    def destroy
      @stop.destroy
      head :no_content 
    end
      
    private
      
      # Use callbacks to share common setup or constraints between actions.
      def set_stop
        @stop = Stop.find(params[:id])
      end


      # Never trust parameters from the scary internet, only allow the white list through.
      def stop_params
        params.require(:stop).permit(:name, :lat, :lon)
      end
      
  end
end