class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Exception, with: :not_found
  # rescue_from ActiveRecord::Unprocessable_entity, with: :unprocessable_entity
  rescue_from ActionController::RoutingError, with: :not_found
  # rescue_from ActiveRecord::RecordNotUnique, :with => :my_rescue_method
  rescue_from ActiveRecord::RecordInvalid, :with => :record_invalid

  def raise_not_found
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end

  def not_found(error)
    respond_to do |format|
      # format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.html { redirect_to "/" }
      format.json { render :json => {:error => error.message}, :status => :not_found }
      format.xml { head :not_found }
      format.any { head :not_found }
    end

  end

  def unprocessable_entity(error)
    respond_to do |format|
      format.json { render :json => {:error => error.record.errors}, :status => :unprocessable_entity }
      format.xml { head :not_found }
      format.any { head :not_found }
    end

  end

  def record_invalid(error)
    validation_errors = {}
    error.record.errors.messages.each do |key,value|
      value_array = []
      value.each {|val| value_array << "#{key} #{val}"}
      validation_errors[key] = value_array
    end
    puts validation_errors.inspect

    respond_to do |format|
      format.json { render :json => { errors: validation_errors }, :status => :unprocessable_entity }
      format.xml { head :not_found }
      format.any { head :not_found }
    end

  end

  def error(error)

    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/500", :layout => false, :status => :error }
      format.json { render :json => {:errors => error.message || "something unusual happened"}, :status => :not_found }
      format.xml { head :not_found }
      format.any { head :not_found }
    end
  end
end
