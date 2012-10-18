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
        # if there are un-paid time sheets, redirect to the last unpaid time sheet
        if user.time_sheets.find_by_paid(false)
          redirect_to user_time_sheet_entries_path(user, user.time_sheets.find_last_by_paid(false))
        else
          # otherwise redirect to the time sheets path
          redirect_to user_time_sheets_path(user)
        end
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
