require "administrate/base_dashboard"

class BookingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    order: Field::BelongsTo,
    user: Field::HasOne,
    reservable: Field::BelongsTo,
    reservable_options: Field::HasMany.with_options(class_name: "BookingReservableOption"),
    id: Field::Number,
    start_time: Field::DateTime,
    end_time: Field::DateTime,
    booking_date: Field::DateTime,
    number_of_players: Field::Number,
    options: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    checked_in: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :order,
    :user,
    :reservable,
    :reservable_options,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :order,
    :user,
    :reservable,
    :reservable_options,
    :id,
    :start_time,
    :end_time,
    :booking_date,
    :number_of_players,
    :options,
    :created_at,
    :updated_at,
    :checked_in,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :order,
    :user,
    :reservable,
    :reservable_options,
    :start_time,
    :end_time,
    :booking_date,
    :number_of_players,
    :options,
    :checked_in,
  ].freeze

  # Overwrite this method to customize how bookings are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(booking)
  #   "Booking ##{booking.id}"
  # end
end
