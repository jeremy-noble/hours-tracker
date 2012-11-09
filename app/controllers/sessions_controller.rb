class SessionsController < ApplicationController
  skip_authorization_check

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      if user.admin?
        redirect_to call_in_hours_path
      else
        # if there are un-paid time sheets, redirect to the last unpaid time sheet
        if user.time_sheets.where(paid: false).count > 0
          redirect_to user_time_sheet_entries_path(user, user.time_sheets.find_by_paid(false))
        else
          # otherwise create a new time sheet and redirect to it
          new_time_sheet = TimeSheet.new
          new_time_sheet.user_id = user.id
          new_time_sheet.save
          redirect_to user_time_sheet_entries_path(user, new_time_sheet)
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
