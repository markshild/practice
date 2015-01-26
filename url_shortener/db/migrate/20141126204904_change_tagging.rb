class ChangeTagging < ActiveRecord::Migration
  def change
    add_index :taggings, :shortened_url_id
    add_index :taggings, :tag_topic_id
  end
end
