class CallInHoursController < ApplicationController
  authorize_resource :class => false
  def index
    @time_sheets = TimeSheet.unscoped.where('time_sheets.paid'=> false).joins(:user).order("LOWER(last_name) asc, created_at desc")
  end

  def mark_paid
    @time_sheets = TimeSheet.find(params[:time_sheet_ids])
    @time_sheets.each do |time_sheet|
        # time_sheet.update_attributes!(paid: true)
        time_sheet.mark_paid
    end
    flash[:notice] = "Time Sheets Marked as Paid!"
    # redirect_to call_in_hours_path
    render :template => 'call_in_hours/index'
  end

end