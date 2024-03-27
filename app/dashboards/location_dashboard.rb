# frozen_string_literal: true

require 'administrate/base_dashboard'

class LocationDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    zone: Field::BelongsTo,
    name: Field::String,
    subtitle: Field::String,
    category: Field::Select.with_options(collection: Location::CATEGORIES),
    loc_x: Field::Number,
    loc_z: Field::Number,
    loc_y: Field::Number,
    monsters: Field::HasMany,
    npcs: Field::HasMany,
    public_notes: Field::Text,
    private_notes: Field::Text
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    name
    category
    zone
    monsters
    npcs
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    name
    category
    zone
    subtitle
    loc_x
    loc_z
    loc_y
    monsters
    npcs
    public_notes
    private_notes
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name
    category
    zone
    subtitle
    loc_x
    loc_z
    loc_y
    public_notes
    private_notes
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

  # Overwrite this method to customize how zones are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(resource)
    "#{resource.category.capitalize}: #{resource.name}"
  end
end
