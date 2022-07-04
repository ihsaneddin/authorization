class Ability
  include CanCan::Ability

  def initialize(user)
    # Apply Authorization managing permissions
    user.computed_permissions.call(self, user)

    # You still can add other permissions
    #can :read_public, :all
  end
end