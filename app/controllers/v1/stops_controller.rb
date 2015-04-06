module V1
  class StopsController < ApplicationController
    
    before_action :set_stop, only: [:show, :update, :destroy]
  
    def index 
      @stops = Stop.all.order('name ASC')
      respond_to do |format|
        format.json {render :index}
        format.kml { send_data @stops.to_kml, filename: controller_name + '.kml' }
        format.gpx { send_data @stops.to_gpx, filename: controller_name + '.gpx' }
      end
    end
    
    def show
      @with_stop_sequences = %w(1 yes true).include?(params["with_stop_sequences"])
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
     
    def nearby
      params.permit(:lat, :lon, :radius)
      #default radius
      params[:radius] = 2000 if params[:radius].nil? 
      
      @lat = params[:lat].to_f
      @lon = params[:lon].to_f
      @stops = Stop.nearby(params)
      @stops = @stops.sort_by { |e| e.distance_to(@lat, @lon)}
      
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