class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  
  before_filter :default_response_data
  
  
  # Each Code shall have a Message with the same key. 
  Status = {
    success: "success",
    fail: "fail",
    error: "error"
  }
  
  # allow options
  def options
    render nothing: true
  end
  
  
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
