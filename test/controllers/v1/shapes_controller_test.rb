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
  class ShapesControllerTest < ActionController::TestCase

    def setup
      #
      # By default we assume tha we are NOT on a read_only_mode, that is
      # the API allows to modify the database
      # For tests of read only mode, read_only_mode will be set true
      #
      Rails.configuration.x.read_only_mode = false
    end

    test "should respond to shapes show" do
        assert_routing '/v1/shapes/1', { format: 'json', controller: "v1/shapes", action: "show", io_id: "1" }
    end

    test "should get a shape" do
      @s = gtfs_api_shapes(:shape_one_1)
      xhr :get, :show, {io_id: @s.io_id}
      assert_response :success
      assert_not_nil assigns(:shape)
    end

  end
end
