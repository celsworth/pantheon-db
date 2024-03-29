# frozen_string_literal: true

module Types
  class BaseField < GraphQL::Schema::Field
    argument_class Types::BaseArgument

    def initialize(*args, cache_fragment: { context_key: :current_user }, **kwargs, &block)
      super
    end

    def current_user
      context[:current_user]
    end
  end
end
