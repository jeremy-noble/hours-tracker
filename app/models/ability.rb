class Ability
  include CanCan::Ability

  def initialize(user)

    # not logged in user
    if user.nil? 
      # guest users have no permissions
    else
      # logged in users
      cannot :index, User
      can :read, User, id: user.id
      can [:read, :create], TimeSheet, user_id: user.id
      can :manage, Entry, :time_sheet => { user_id: user.id, paid: false }
      can :read, Entry, :time_sheet => { user_id: user.id, paid: true }
      # Admins 
      if user.admin?
        can :manage, :all
      end
    end 

  end
end
