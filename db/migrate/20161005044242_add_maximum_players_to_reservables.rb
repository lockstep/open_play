class AddMaximumPlayersToReservables < ActiveRecord::Migration[5.0]
  def change
    add_column :reservables, :maximum_players, :integer
  end
end
