class Band < ActiveRecord::Base
  validates :name, presence: true

  has_many :albums, inverse_of: :band, dependent: :destroy
  has_many :tracks, inverse_of: :track

end
