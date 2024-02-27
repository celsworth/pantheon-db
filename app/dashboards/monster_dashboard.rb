# frozen_string_literal: true

require 'administrate/base_dashboard'

class MonsterDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    location: Field::BelongsTo,
    drops: Field::HasMany,
    level: Field::Number,
    name: Field::String,
    elite: Field::Boolean,
    named: Field::Boolean,
    patch: Field::BelongsTo,
    loc_x: Field::Number,
    loc_y: Field::Number,
    loc_z: Field::Number,
    roamer: Field::Boolean
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    name
    location
    level
    elite
    named
    patch
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    name
    location
    level
    elite
    named
    drops
    patch
    loc_x
    loc_y
    loc_z
    roamer
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name
    location
    level
    elite
    named
    drops
    loc_x
    loc_y
    loc_z
    roamer
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

  # Overwrite this method to customize how monsters are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(monster)
    monster.name
  end
end
