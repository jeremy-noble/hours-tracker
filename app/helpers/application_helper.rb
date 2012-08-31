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

end
