class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :title, null: false
      t.integer :owner_id, null: false
      t.text :description
      t.boolean :completed, default: false
      t.string :status, null: false

      t.timestamps
    end
    add_index :goals, :owner_id
  end
end
