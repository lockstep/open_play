require "administrate/base_dashboard"

class LaneDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    activity: Field::BelongsTo,
    options: Field::HasMany.with_options(class_name: "ReservableOption"),
    options_available: Field::HasMany.with_options(class_name: "ReservableOptionsAvailable"),
    bookings: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    type: Field::String,
    interval: Field::Number,
    start_time: TimeField,
    end_time: TimeField,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    maximum_players: Field::Number,
    weekday_price: Field::Number.with_options(decimals: 2),
    weekend_price: Field::Number.with_options(decimals: 2),
    archived: Field::Boolean,
    per_person_weekday_price: Field::Number.with_options(decimals: 2),
    per_person_weekend_price: Field::Number.with_options(decimals: 2),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :interval,
    :start_time,
    :end_time
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :interval,
    :start_time,
    :end_time,
    :maximum_players,
    :weekday_price,
    :weekend_price,
    :per_person_weekday_price,
    :per_person_weekend_price,
    :archived,
    :activity,
    :options,
    :options_available,
    :bookings
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :type,
    :interval,
    :start_time,
    :end_time,
    :maximum_players,
    :weekday_price,
    :weekend_price,
    :archived,
    :per_person_weekday_price,
    :per_person_weekend_price,
    :activity
  ].freeze

  # Overwrite this method to customize how lanes are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(lane)
  #   "Lane ##{lane.id}"
  # end
end
