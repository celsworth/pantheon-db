# frozen_string_literal: true

module Types
  module Payloads
    class ZonePayloadType < Types::BaseObject
      field :zone, ZoneType
      field :errors, [String], null: false
    end
  end
end
