class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.integer :msg_id
      t.integer :user_id
      t.text :reply
      t.integer :dir
      t.integer :gold

      t.timestamps
    end
  end
end
