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
  class StopsController < ApplicationController
    
    before_action :set_stop, only: [:show, :update, :destroy]
  
    def index 
      @stops = Stop.all.ordered
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