# frozen_string_literal: true

module Types
  class QuestRewardType < Types::BaseObject
    description <<~DESC
      A single quest reward. If a quest has multiple rewards, create multiple of these per quest.

      Only one of the following should be populated: skill, item, copper, standing, xp.

      The one that is populated describes what the reward is, for example item will point to the item object; skill is a string like "sprinting"; copper/standing/xp are just booleans.

      Then, amount should be set to express how much of the reward you get.

      For example if this is an item reward, and amount is 2, then you get 2 of the linked item.

      Or, if xp is true and amount is 400, then you get 400 XP for this particular reward.

      Text can be used if the reward doesn't fit neatly into any predefined columns.
    DESC
    field :id, ID, null: false
    field :patch, PatchType, null: false

    field :quest, QuestType, null: false

    field :skill, String
    field :item, ItemType
    field :copper, Boolean
    field :standing, Boolean
    field :xp, Boolean
    field :amount, Float

    field :readable, String, description: <<~DESC
      A dynamically generated field that attempts to summarise the reward based on all the other fields, so for example if copper is true, and amount is 50, this will return "50 Copper"

      This is mostly for convenience and is very rudimentary!
    DESC
    field :text, String

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
