module ApplicationHelper

  def yesno(bool)
    if bool
      'Yes'
    else
      'No'
    end
  end

  def nice_date(date)
    date.strftime("%b %e, %Y")
  end

  def paid_time_sheets?(time_sheets)
    if time_sheets.where(paid: false).count > 0
      return true
    else
      return false
    end
  end

end
