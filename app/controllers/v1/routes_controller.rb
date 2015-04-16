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
  class RoutesController < ApplicationController
    before_action :set_route, only: [:show, :update, :destroy]
    
    def index 
      @with_trips = %w(1 yes true).include?(params["with_trips"])
      if @with_trips
        @routes = Route.all.includes(:trips).order('name ASC')
      else
        @routes = Route.all.order('name ASC')
      end
    end
        
    def show
    end   
    
    def create
      @route = Route.new(route_params)
      if @route.save
        render :show, status: :created, location: v1_route_path(@route)
      else
       render_json_fail(:unprocessable_entity, @route.errors)
      end
    end    
    
    def update
      if @route.update(route_params)
        render :show, status: :ok, location: v1_route_path(@route) 
      else
        render_json_fail(:unprocessable_entity, @route.errors)  
      end
    end
      
    def destroy
      @route.destroy
      head :no_content 
    end    
     
    private
        
      # Use callbacks to share common setup or constraints between actions.
      def set_route
        @route = Route.find(params[:id])
      end
      
      # Never trust parameters from the scary internet, only allow the white list through.
      def route_params
        params.require(:route).permit(:name)
      end   
  end
end