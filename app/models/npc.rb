# frozen_string_literal: true

class Npc < ApplicationRecord
  include Jumploc

  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  belongs_to :location
  has_one :zone, through: :location

  has_and_belongs_to_many :sells_items, class_name: 'Item', before_add: :check_sells_items
  has_and_belongs_to_many :images
  has_many :quests_given, class_name: 'Quest', foreign_key: :giver_id, dependent: :nullify
  has_many :quests_received, class_name: 'Quest', foreign_key: :receiver_id, dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :location, presence: true

  private

  def check_sells_items(item)
    return unless sells_items.include?(item)

    errors.add :base, 'already sold by this npc'
    raise ActiveRecord::Rollback
  end
end
