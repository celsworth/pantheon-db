# frozen_string_literal: true

class QuestObjective < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  validates :quest, presence: true

  validate :only_item_or_monster
  validate :text_if_no_item_or_monster
  before_save :default_amount_if_item_or_monster

  belongs_to :quest, inverse_of: :quest_objectives

  belongs_to :item, optional: true
  belongs_to :monster, optional: true

  def readable
    [
      ("#{amount.round} #{item.name}" if item),
      ("#{amount.round} #{monster.name}" if monster)
    ].select { _1 }.first
  end

  private

  def type_count
    [item.present?, monster.present?].count { _1 }
  end

  def only_item_or_monster
    return unless type_count > 1

    errors.add(:base, 'only one of an item or a monster can be set')
  end

  def text_if_no_item_or_monster
    return if type_count.positive?

    errors.add(:text, 'required if no monster or item set') if text.blank?
  end

  def default_amount_if_item_or_monster
    return if type_count.zero?

    self.amount ||= 1
  end
end
