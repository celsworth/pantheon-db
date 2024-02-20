# frozen_string_literal: true

module Types
  module Inputs
    class OperatorType < Types::BaseEnum
      value 'EQ', value: '='
      value 'LT', value: '<'
      value 'LTE', value: '<='
      value 'GT', value: '>'
      value 'GTE', value: '>='
    end
  end
end
