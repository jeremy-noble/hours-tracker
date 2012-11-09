class CallInHoursController < ApplicationController
  authorize_resource :class => false
  def index
    @time_sheets = TimeSheet.where('time_sheets.paid'=> false).order('created_at desc').joins(:user).order("LOWER(last_name) asc")
    
    # calculate total hours and salary for entire time sheet
    @entire_total_hours = 0
    @entire_total_salary = 0
    
    @time_sheets.each do |time_sheet|
      if time_sheet.hourly_only?
        @entire_total_hours = @entire_total_hours + time_sheet.total_hours
      else
        @entire_total_salary = @entire_total_salary + time_sheet.total_cash
      end
    end
  end

  def mark_paid
    @time_sheets = TimeSheet.find(params[:time_sheet_ids])
    @time_sheets.each do |time_sheet|
        # time_sheet.update_attributes!(paid: true)
        time_sheet.mark_paid
    end
    flash[:notice] = "Time Sheets Marked as Paid!"
    redirect_to call_in_hours_path
  end

end