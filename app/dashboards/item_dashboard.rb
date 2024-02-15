# frozen_string_literal: true

require 'administrate/base_dashboard'

class ItemDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    dropped_by: Field::HasMany,
    sold_by: Field::HasMany,
    starts_quest: Field::HasOne,
    reward_from_quest: Field::BelongsTo,
    name: Field::String,
    category: Field::Select.with_options(collection: Item::CATEGORIES, include_blank: 'none'),
    required_level: Field::Number,
    buy_price: Field::Number,
    sell_price: Field::Number,
    weight: Field::Number,
    slot: Field::Select.with_options(collection: Item::SLOTS, include_blank: 'none'),
    stats: Field::JSONB,
    classes: Field::JSONB,
    attrs: Field::JSONB,
    patch: Field::BelongsTo
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    name
    category
    buy_price
    sell_price
    weight
    slot
    starts_quest
    patch
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    name
    category
    sell_price
    weight
    required_level
    slot
    dropped_by
    sold_by
    starts_quest
    reward_from_quest
    stats
    classes
    attrs
    patch
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.

  # classes doesn't work here, doesn't support the array very well
  FORM_ATTRIBUTES = %i[
    name
    category
    buy_price
    sell_price
    weight
    required_level
    slot
    dropped_by
    sold_by
    reward_from_quest
    stats
    classes
    attrs
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how items are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(item)
    item.name
  end
end
