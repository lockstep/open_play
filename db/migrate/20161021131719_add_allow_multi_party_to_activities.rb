class AddAllowMultiPartyToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :allow_multi_party_bookings, :boolean, default: false
  end
end
