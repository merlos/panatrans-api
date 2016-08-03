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
  class ShapesController < ApplicationController

    #before_action :set_shape, only: [:show, :update, :destroy]
    before_action :set_shape, only: [:show]
    #Note check_read_only_mode is defined in Application controller
    #before_action :check_read_only_mode, only: [:create, :update, :destroy]



    def show
    end

    #def create
    #  @stop = GtfsApi::Stop.new(stop_params)
    #  if @stop.save
    #     render :show, status: :created, location: v1_stop_path(@stop)
    #  else
    #   render_json_fail(:unprocessable_entity, @stop.errors)
    #  end
    #end

    #def update
    #  if @stop.update(stop_params)
    #    render :show, status: :ok, location: v1_stop_path(@stop)
    #  else
    #    render_json_fail(:unprocessable_entity, @stop.errors)
    #  end
    #end

    #def destroy
    #  @stop.destroy
    #  head :no_content
    #end


    private

      # Use callbacks to share common setup or constraints between actions.
      def set_shape
        @shape = GtfsApi::Shape.where(io_id: params[:io_id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def shape_params
        params.require(:shape).permit(:io_id)
      end


  end
end
