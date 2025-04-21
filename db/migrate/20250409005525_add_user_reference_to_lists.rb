class AddUserReferenceToLists < ActiveRecord::Migration[7.1]
  def change
    add_reference :lists, :user, index: true, foreign_key: true
  end
end
