class ChangeShortenendUrlsVarCharLength < ActiveRecord::Migration
  def change
    change_table :shortened_urls do |t|
      t.change :long_url, :string, limit: 1024
    end
  end
end
