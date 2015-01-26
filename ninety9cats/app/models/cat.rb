class Cat < ActiveRecord::Base
  COLORS = %w(black white orange brown)
  validates :birthdate, :color, :name, :sex, :user_id, presence: true
  validates :color, inclusion: { in: COLORS}
  validates :sex, inclusion: { in: %w( M F )}

  belongs_to :user
  has_many :cat_rental_requests, dependent: :destroy

  def age
    age = Date.today.year - birthdate.year
    age < 1 ? 1 : age
  end
end
