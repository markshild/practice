class User < ActiveRecord::Base
  validates :email, :password_digest, :session_token, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :email, uniqueness: true

  has_many :notes, dependent: :destroy

  after_initialize :ensure_token

  attr_reader :password

  def self.find_by_creds(email, password)
    user = User.find_by(email: email)
    return nil if user.nil? || user.is_password?(password)
    user
  end

  def generate_token
    SecureRandom.urlsafe_base64(16)
  end

  def reset_token!
    self.session_token = generate_token
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  private
  def ensure_token
    self.session_token ||= generate_token
  end
end
