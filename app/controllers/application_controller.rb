class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :default_response_data


  # Constants
  
  # Response CODES and Messages
  
  # Each Code shall have a Message with the same key. 
  Status = {
    success: "success",
    fail: "fail",
    error: "error"
  }
  
  protected

  def default_response_data
    @status = Status[:success]
  end
  
  def render_json_fail(http_status, error_hash)
    json_fail = {
      status: Status[:fail],
      errors: error_hash 
    }
    render json: json_fail, status: http_status
  end
end
