class AddArchivedToReservables < ActiveRecord::Migration[5.0]
  def change
    add_column :reservables, :archived, :boolean, default: false
  end
end
