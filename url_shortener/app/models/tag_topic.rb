class TagTopic < ActiveRecord::Base
  validates :topic, presence: true


  has_many(
    :taggings,
    class_name: 'Tagging',
    foreign_key: :tag_topic_id,
    primary_key: :id

  )

  has_many(
    :shortened_urls,
    through: :taggings,
    source: :shortened_url
  )

  def five_most_popular_urls
    self
      .shortened_urls
      .joins(:visits)
      .group('shortened_urls.id')
      .order("COUNT(visits.*) DESC")
      .limit(5)
  end


end
