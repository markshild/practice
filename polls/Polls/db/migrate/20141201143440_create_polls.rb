class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title
      t.integer :author_user_id
      t.timestamps
    end

    add_index :polls, :author_user_id
  end
end
