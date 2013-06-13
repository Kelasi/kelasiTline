class AddPictureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :picture, :string, default: "assets/anonymous.jpg"
  end
end
