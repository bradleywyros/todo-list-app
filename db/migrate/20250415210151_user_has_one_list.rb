class UserHasOneList < ActiveRecord::Migration[7.1]
  def change
    remove_column :lists, :user_id
    add_reference :lists, :user, null: false, foreign_key: true
  end
end
