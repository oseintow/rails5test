class ErrorsController < ApplicationController
  def show
    @exception = env['action_dispatch.exception']
    # render action: request.path[1..-1]
    respond_to do |format|
      format.html { render :action => request.path[1..-1], :layout => false, :status => :error }
      format.json { render :json => {:error => @exception.message || "something unusual happened"}, :status => request.path[1..-1] }
    end
  end
end
