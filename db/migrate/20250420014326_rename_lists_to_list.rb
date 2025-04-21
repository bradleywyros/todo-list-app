class RenameListsToList < ActiveRecord::Migration[7.1]
  def change
    if table_exists?(:lists)
      rename_table :lists, :list
    end
  end
end
