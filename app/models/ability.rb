class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here.
    return if user.nil?

    if user.superadmin?
      can :manage, :all

    elsif user.admin?
      locations = Location.with_role( :admin, user )
      location_ids = locations.ids
      nooks = Nook.where( location_id: location_ids )
      nook_ids = nooks.ids
      can :manage, Location, id: location_ids
      cannot :destroy, Location
      can :manage, Nook, id: nook_ids
      can :manage, Reservation, nook_id: nook_ids
      can :manage, Role

    else #Patron
      can :read, [ Location, Nook ]
      can :manage, Reservation, id: user.reservations.ids
      can :read, Reservation, public: true
    end
  end
end
