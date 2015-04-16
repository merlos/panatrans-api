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