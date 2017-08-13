class AddPartyRoomColumnsToReservables < ActiveRecord::Migration[5.0]
  def change
    add_column :reservables, :description, :text
    add_column :reservables, :headcount, :integer, default: 0
    add_column :reservables, :maximum_players_per_sub_reservable, :integer, default: 0
  end
end
