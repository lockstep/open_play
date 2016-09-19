class ChangeDataTypeForBusinessDescription < ActiveRecord::Migration[5.0]
  def change
    change_column :businesses, :description,  :text
  end
end
