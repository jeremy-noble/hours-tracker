class SessionsController < ApplicationController
  skip_authorization_check

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      if user.admin?
        redirect_to users_path
      else
        redirect_to user_time_sheets_path(user)
      end
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to login_url
  end
end
