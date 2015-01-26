class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true

  has_many(
    :contacts,
    class_name: 'Contact',
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(
    :user_shares,
    class_name: 'ContactShare',
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many :shared_contacts, through: :user_shares, source: :contact

  has_many :comments, as: :commentable
end
