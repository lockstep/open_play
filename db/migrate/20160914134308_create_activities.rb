class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :name
      t.references :business, foreign_key: true
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
