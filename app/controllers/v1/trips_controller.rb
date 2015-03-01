module V1
  class TripsController < ApplicationController
    before_action :set_trip, only: [:show, :update, :destroy]
    
    def index 
      @trips = Trip.all.includes(:route)
    end
    
    def show
    end
    
    def create
      @trip = Trip.new(trip_params)
      if @trip.save
        render :show, status: :created, location: v1_trip_path(@trip)
      else
       render_json_fail(:unprocessable_entity, @trip.errors)
      end
    end
    
    def update
      if @trip.update(trip_params)
        render :show, status: :ok, location: v1_trip_path(@trip) 
      else
        render_json_fail(:unprocessable_entity, @trip.errors)  
      end
    end
    
    def destroy
      @trip.destroy
      head :no_content 
    end
     
    private
    
      # Use callbacks to share common setup or constraints between actions.
      def set_trip
        @trip = Trip.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def trip_params
        params.require(:trip).permit(:headsign, :direction, :route_id)
      end
      
  end
end