# frozen_string_literal: true

module Types
  class BaseField < GraphQL::Schema::Field
    argument_class Types::BaseArgument

    def initialize(*args, cache_fragment: true, **kwargs, &block)
      super
    end
  end
end
