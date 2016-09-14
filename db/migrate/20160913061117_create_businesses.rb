class CreateBusinesses < ActiveRecord::Migration[5.0]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
