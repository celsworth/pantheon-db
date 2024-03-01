# frozen_string_literal: true

module Types
  class ImageType < Types::BaseObject
    field :id, ID, null: false

    field :size, Integer, null: false
    field :mime, String, null: false

    field :url, String, null: false
    def url
      "#{ENV.fetch('BASE_URL')}/images/#{object.id}"
    end

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
