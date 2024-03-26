# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # not really bothering with read perms yet, everything is public
    can :read, :all

    return unless user.present?

    if user.admin?
      admin_abilities
    elsif user.contributor?
      contributor_abilities(user)
    end
  end

  def contributor_abilities(user)
    # can :create, :all

    can :manage, :all
    cannot :manage, User

    can :read, User, id: user.id
  end

  def admin_abilities
    can :manage, :all
  end
end
