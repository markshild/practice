class Track < ActiveRecord::Base
  validates :album_id, :name, :track_type, presence: true
  validates :track_type, inclusion: { in: %w(Bonus Regular) }
  belongs_to :album, inverse_of: :tracks
  has_many :notes, dependent: :destroy
end
