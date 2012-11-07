class CallInHoursController < ApplicationController
  def index
    authorize! :index, :call_in_hours
    
    # @time_sheet = @user.time_sheets.find(params[:id])

    # raise @user.ability.inspect
    # authorize! :call_in_hours, :time_sheets
    # @users = User.all

    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.json { render json: @users }
    # end


    # authorize! :index, Ability
    # find all users with unpaid timesheets
    # @users = User.order("LOWER(last_name) asc").joins(:time_sheets).where('time_sheets.paid'=> false).order('created_at desc')
    
    # raise @users.inspect

    @time_sheets = TimeSheet.where('time_sheets.paid'=> false).order('created_at desc').joins(:user).order("LOWER(last_name) asc")

    # @time_sheets = TimeSheet.

    # @user = User.find(:all, joins: :time_sheets,
      # conditions: { time_sheets: {paid: false} })

  end

end