class UserRenameListstoListReference < ActiveRecord::Migration[7.1]
  def change
    if table_exists?(:lists)
      remove_column :lists, :user_id
      add_reference :list, :user, null: false, foreign_key: true
    end
  end
end
