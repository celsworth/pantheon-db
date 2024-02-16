# frozen_string_literal: true

class QuestReward < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  # this really needs to move somewhere else
  SKILLS = %w[sprinting].freeze

  validates :skill, inclusion: { in: SKILLS }, allow_blank: true
  validate :only_one_set
  validate :text_if_none_set
  before_save :default_amount_if_one_set

  belongs_to :quest, inverse_of: :quest_objectives

  belongs_to :item, optional: true

  def readable
    [("#{amount.round} #{skill}" if skill),
     ("#{amount.round} #{item.name}" if item),
     ("#{amount.round} Copper" if copper),
     ("#{amount} Standing" if standing),
     ("#{amount.round} XP" if xp)]
      .select { _1 }.first
  end

  private

  def type_count
    [skill.present?, item.present?, copper, standing, xp].count { _1 }
  end

  def only_one_set
    return unless type_count > 1

    errors.add(:base, 'only one reward type can be set')
  end

  def text_if_none_set
    return if type_count.positive?

    errors.add(:text, 'required if no reward type set') if text.blank?
  end

  def default_amount_if_one_set
    return if type_count.zero?

    self.amount ||= 1
  end
end
