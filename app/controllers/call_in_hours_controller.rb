class CallInHoursController < ApplicationController

  def index
    authorize! :index, :call_in_hours
    @time_sheets = TimeSheet.where('time_sheets.paid'=> false).order('created_at desc').joins(:user).order("LOWER(last_name) asc")
  end

  def mark_paid

  end

end