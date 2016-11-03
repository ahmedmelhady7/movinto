class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  
  def index
  end
  
  def admin
    if current_user.is_admin
      @message = "you are a freaking ADMIN!"
    else
      flash[:error] = "you are not allowed"
      redirect_to root_path
    end
  end
  
end
