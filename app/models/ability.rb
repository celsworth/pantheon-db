# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    # not really bothering with read perms yet, everything is public
    can :read, :all

    # blanket admin access, could do roles later
    return unless user.admin?

    can :manage, :all
  end
end
