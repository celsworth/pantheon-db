# frozen_string_literal: true

class QuestObjective < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  validate :only_item_or_monster
  validate :text_if_no_item_or_monster
  before_save :default_amount_if_item_or_monster

  belongs_to :quest, inverse_of: :quest_objectives

  belongs_to :item, optional: true
  belongs_to :monster, optional: true

  def only_item_or_monster
    return unless item && monster

    errors.add(:base, 'only one of an item or a monster can be set')
  end

  def text_if_no_item_or_monster
    return if item || monster

    errors.add(:text, 'required if no monster or item set') if text.blank?
  end

  def default_amount_if_item_or_monster
    return if !item && !monster

    self.amount ||= 1
  end
end
