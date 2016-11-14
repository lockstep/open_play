require "administrate/base_dashboard"

class BowlingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    business: Field::BelongsTo,
    reservables: Field::HasMany,
    orders: Field::HasMany,
    lanes: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    start_time: TimeField,
    end_time: TimeField,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    type: Field::String,
    prevent_back_to_back_booking: Field::Boolean,
    archived: Field::Boolean,
    allow_multi_party_bookings: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :start_time,
    :end_time,
    :reservables,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :start_time,
    :end_time,
    :prevent_back_to_back_booking,
    :archived,
    :allow_multi_party_bookings,
    :business,
    :lanes,
    :orders
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :start_time,
    :end_time,
    :prevent_back_to_back_booking,
    :archived,
    :allow_multi_party_bookings,
    :business
  ].freeze

  # Overwrite this method to customize how bowlings are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(bowling)
  #   "Bowling ##{bowling.id}"
  # end
end
