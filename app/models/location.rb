# frozen_string_literal: true

class Location < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :zone
  belongs_to :settlement, optional: true
  belongs_to :dungeon, optional: true

  has_many :monsters
  has_many :npcs
end
