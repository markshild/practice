class Cheer < ActiveRecord::Base
  validates :user_id, :goal_id, presence: true
  validates :user_id, uniqueness: { scope: :goal_id }
  validate :too_many_cheers

  belongs_to :user, inverse_of: :cheers
  belongs_to :goal, inverse_of: :cheers

  private

  def too_many_cheers
    num_cheers = Cheer.where(user_id: self.user_id).count
    if num_cheers > 4
      errors[:base] << "Cheer is a limited resource. You have given all yours away :("
    end
  end
end
