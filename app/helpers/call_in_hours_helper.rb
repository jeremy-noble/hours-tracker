module CallInHoursHelper

  def all_total_hours(time_sheets)
    all_total_hours = 0
    time_sheets.each do |time_sheet|
      if time_sheet.hourly_only?
        all_total_hours = all_total_hours + time_sheet.total_hours
      end
    end
    return all_total_hours
  end

  def all_total_salary(time_sheets)
    all_total_salary = 0
    time_sheets.each do |time_sheet|
      if !time_sheet.hourly_only?
        all_total_salary = all_total_salary + time_sheet.total_cash
      end
    end
    return all_total_salary
  end

end