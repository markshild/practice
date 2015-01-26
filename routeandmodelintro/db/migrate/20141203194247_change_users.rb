class ChangeUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :email, :name
      t.string :username
    end
  end
end
