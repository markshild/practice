class Tagging < ActiveRecord::Base
  validates :shortened_url_id, :tag_topic_id, presence: true

  belongs_to(
    :tag_topic,
    class_name: "TagTopic",
    foreign_key: :tag_topic_id,
    primary_key: :id
  )

  belongs_to(
  :shortened_url,
  class_name: "ShortenedUrl",
  foreign_key: :shortened_url_id,
  primary_key: :id
  )

end
