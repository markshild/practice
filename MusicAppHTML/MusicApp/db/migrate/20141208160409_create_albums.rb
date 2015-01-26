class CreateAlbums < ActiveRecord::Migration

  def change
    create_table :albums do |t|
      t.string :name
      t.integer :band_id
      t.string :album_type
      t.timestamps
    end
  end
end
