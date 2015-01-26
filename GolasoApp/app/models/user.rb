class User < ActiveRecord::Base
  include Commentable

  attr_reader :password
  validates :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: { message: "Password can't be blank" }
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token

  has_many :goals, class_name: 'Goal', foreign_key: :owner_id, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :authored_comments, class_name: 'Comment', foreign_key: :author_id, dependent: :destroy
  has_many :cheers, dependent: :destroy, inverse_of: :user
  has_many :cheered_goals, through: :cheers, source: :goal

  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)
    return nil if user.nil? || !user.is_password?(password)
    user
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

end
