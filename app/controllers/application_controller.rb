class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Exception, with: :not_found
  rescue_from Exception, with: :unprocessable_entity
  rescue_from ActionController::RoutingError, with: :not_found

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
      # format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      # format.html { redirect_to "/" }
      format.json { render :json => {:error => error.message}, :status => :unprocessable_entity }
      format.xml { head :not_found }
      format.any { head :not_found }
    end

  end

  def error(error)
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/500", :layout => false, :status => :error }
      format.json { render :json => {:error => error.message || "something unusual happened"}, :status => :not_found }
      format.xml { head :not_found }
      format.any { head :not_found }
    end
  end
end
