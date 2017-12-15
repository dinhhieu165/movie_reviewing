class SessionsController < ApplicationController
    
  def create
    user = User.find_by email: params[:session][:email].downcase
    
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        user.admin ? redirect_back_or(admin_root_url) : redirect_back_or(root_url)
      else
        message = t "flash.active_account"
        message += t "flash.check_email"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "flash.invalid"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
