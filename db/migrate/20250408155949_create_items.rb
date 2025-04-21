class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :title
      t.text :description
      t.string :status, default: "pending"
      t.datetime :duedate
      t.references :list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
