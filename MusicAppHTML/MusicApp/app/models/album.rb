class Album < ActiveRecord::Base
  validates :band_id, :name, :album_type, presence: true
  validates :album_type, inclusion: { in: %w(Studio Live) }
  belongs_to :band, inverse_of: :albums
  has_many :tracks, inverse_of: :album, dependent: :destroy
end
