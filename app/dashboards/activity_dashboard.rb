require "administrate/base_dashboard"

class ActivityDashboard < Administrate::BaseDashboard
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
    id: Field::Number,
    name: Field::String,
    start_time: Field::DateTime,
    end_time: Field::DateTime,
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
    :business,
    :reservables,
    :orders,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :business,
    :reservables,
    :orders,
    :id,
    :name,
    :start_time,
    :end_time,
    :created_at,
    :updated_at,
    :type,
    :prevent_back_to_back_booking,
    :archived,
    :allow_multi_party_bookings,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :business,
    :reservables,
    :orders,
    :name,
    :start_time,
    :end_time,
    :type,
    :prevent_back_to_back_booking,
    :archived,
    :allow_multi_party_bookings,
  ].freeze

  # Overwrite this method to customize how activities are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(activity)
    "#{activity.name}"
  end
end
