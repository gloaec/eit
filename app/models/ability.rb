class Ability
  include CanCan::Ability

  def initialize(user)
       user ||= User.new # guest user (not logged in)

       if user.role? :contact
       end
       if user.role? :user
         can :read, Channel do |channel|
           channel.users.include? user
         end
	 can :read, Program do |program|
	   can? :read, program.channel
	 end
	 can :read, Event do |event|
           can? :read, event.program
	 end
       end
       if user.role? :admin
         can :manage, Channel do |channel|
           channel.admins.include? user
         end
       end
       if user.role? :superadmin
         can :manage, :all
       end

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
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
