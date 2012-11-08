class CallInHoursController < ApplicationController

  def index
    authorize! :index, :call_in_hours
    @time_sheets = TimeSheet.where('time_sheets.paid'=> false).order('created_at desc').joins(:user).order("LOWER(last_name) asc")
  end

  def mark_paid
    authorize! :mark_paid, :call_in_hours

    @time_sheets = TimeSheet.find(params[:time_sheet_ids])
    @time_sheets.each do |time_sheet|
        time_sheet.update_attributes!(paid: true)
    end
    flash[:notice] = "Time Sheets Marked as Paid!"
    redirect_to call_in_hours_path
  end

end