# frozen_string_literal: true

module Types
  module Results
    class SuccessResultType < BaseObject
      field :success, Boolean, null: false
      field :errors, [String], null: false
    end
  end
end
