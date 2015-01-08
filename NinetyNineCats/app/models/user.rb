class User < ActiveRecord::Base
  attr_reader :password

  validates :user_name, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  has_many :cats, dependent: :destroy
  has_many :cat_rental_requests, dependent: :destroy
  has_many :user_sessions, dependent: :destroy

  def self.find_by_credentials(user_name, password)
    user = User.find_by_user_name(user_name)
    return nil if user.nil?

    user.is_password?(password) ? user : nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  # def reset_session_token!
  #   UserSession.find_by_session_token(session[:session_token]).delete
  # end

end
