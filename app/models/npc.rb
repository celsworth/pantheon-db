# frozen_string_literal: true

class Npc < ApplicationRecord
  belongs_to :zone

  has_many :quests_given, class_name: 'Quest', foreign_key: :giver_id
  has_many :quests_received, class_name: 'Quest', foreign_key: :receiver_id
end
