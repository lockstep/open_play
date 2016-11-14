require "administrate/base_dashboard"

class BusinessDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    activities: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    description: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    phone_number: Field::String,
    address: Field::String,
    profile_picture_file_name: Field::String,
    profile_picture_content_type: Field::String,
    profile_picture_file_size: Field::Number,
    profile_picture_updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :activities,
    :id,
    :name,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :activities,
    :id,
    :name,
    :description,
    :created_at,
    :updated_at,
    :phone_number,
    :address,
    :profile_picture_file_name,
    :profile_picture_content_type,
    :profile_picture_file_size,
    :profile_picture_updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :activities,
    :name,
    :description,
    :phone_number,
    :address,
    :profile_picture_file_name,
    :profile_picture_content_type,
    :profile_picture_file_size,
    :profile_picture_updated_at,
  ].freeze

  # Overwrite this method to customize how businesses are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(business)
  #   "Business ##{business.id}"
  # end
end
