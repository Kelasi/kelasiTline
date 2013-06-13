class ChangeParentColumnNameToParentId < ActiveRecord::Migration
  def up
  	rename_column :posts, :parent, :parent_id
  end
end
