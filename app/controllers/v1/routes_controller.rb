module V1
  class RoutesController < ApplicationController
    before_action :set_route, only: [:show, :update, :destroy]
    
    def index 
      @routes = Route.all.order('name ASC')
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