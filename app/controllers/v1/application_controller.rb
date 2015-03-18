module V1
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
  
    # for OPTIONS method routes.
    # This is related with Angular JS and CORS
    def options
      render nothing: true
    end
    
    # gets the resource 
    def since
      time = Time.at(params[:seconds_since_epoc].to_i).to_datetime
      
      # only return the data if klass is a model 
      models_as_strings= []
      ActiveRecord::Base.descendants.each { |d| models_as_strings.push(d.to_s) if d.to_s != "ActiveRecord::SchemaMigration" }
      
      if models_as_strings.include? controller_name.classify
        klass = controller_name.classify.constantize
        @results = klass.where('updated_at >= :time', time: time)  
        respond_to do |format|
          format.json { render :since }
          format.csv { send_data @results.as_csv, filename: controller_name + '.csv' }
          #format.xls # { send_data @products.to_csv(col_sep: "\t") }
        end
      else
        respond_to do |format|
          format.json { render_json_fail(:not_found, 'Unknown resource') }
          format.csv { render status: :not_found }
        end
      end
    end
  
    protected

    def default_response_data
      @status = Status[:success]
      # prettify param makes the json output more readable for humans. 
      # By default it's false.
      @prettify = %w(1 yes true).include?(params["prettify"])
    end
  
    def render_json_fail(http_status, error_hash)
      json_fail = {
        status: Status[:fail],
        errors: error_hash 
      }
      render json: json_fail, status: http_status
    end
  end
end