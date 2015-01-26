class Goal < ActiveRecord::Base
  include Commentable

  validates :owner_id, :title, :status, presence: true
  validates :status, inclusion: ["Private", "Public"]

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :cheers, dependent: :destroy, inverse_of: :goal
  has_many :cheerers, through: :cheers, source: :user


end
