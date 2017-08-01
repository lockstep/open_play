class AddPictureToActivity < ActiveRecord::Migration[5.0]
  def change
    add_attachment :activities, :picture
  end
end
