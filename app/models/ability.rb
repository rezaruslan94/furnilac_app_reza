class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    elsif user.qc?
      # can [:create], [Employee]
      can [:read], [Department, Division, Area, Item, Pic, Employee]
      can [:create], [Department, Division, Area, Item, Pic, Employee]
      can [:update], [Department, Division, Area, Item, Pic, Employee]
      can [:destroy], [Department, Division, Area, Item, Pic, Employee]
      can [:bulk_new], [Department, Division, Area, Item, Pic, Employee]
      can [:bulk_insert], [Department, Division, Area, Item, Pic, Employee]
      # can [:productivity_people], [Department, Division, Area, Item, Pic]
      # can [:productivity_person], [Department, Division, Area, Item, Pic]
      # can [:read], [Department]
    elsif user.faps?
      can [:read], [Buyer, TerminalFourth]
      can [:create], [Buyer, TerminalFourth]
      can [:update], [Buyer, TerminalFourth]
      can [:destroy], [Buyer, TerminalFourth]
      can [:bulk_new], [Buyer, TerminalFourth]
      can [:bulk_insert], [Buyer, TerminalFourth]
      can [:edit_finish], [Buyer, TerminalFourth]
      can [:update_finish], [Buyer, TerminalFourth]
    else
      cannot :read, :all
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
