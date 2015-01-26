class Romovecolumnfromtracks < ActiveRecord::Migration
  def change
    remove_column :tracks, :band_id
  end
end
