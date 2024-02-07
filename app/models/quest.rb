# frozen_string_literal: true

class Quest < ApplicationRecord
  belongs_to :giver, class_name: 'Npc'
  belongs_to :receiver, class_name: 'Npc', optional: true

  belongs_to :drops_from, class_name: 'Npc', optional: true

  has_many :quest_objectives
end
