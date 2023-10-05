class User < ApplicationRecord
  validates_presence_of :first_name, :last_name, allow_nil: true
  validates_presence_of :google_id, allow_nil: true
  validates_presence_of :token, allow_nil: true
  validates :email, uniqueness: true, presence: true
  validates :password_digest, presence: true, confirmation: true
  has_secure_password
  

  validate do |user|
    user.errors.add(:base, "Invalid Credentials") if user.email.blank?
  end

  def self.from_google_auth(auth)
    user = User.find_by(google_id: auth[:uid]) || User.new
    user.attributes = {
      google_id: auth[:uid],
      email: auth[:info][:email],
      first_name: auth[:info][:first_name],
      last_name: auth[:info][:last_name],
      token: auth[:credentials][:token],
      refresh_token: auth[:credentials][:refresh_token],
      password: SecureRandom.hex(15)
    }
    if user.save
      user
    else
      user
    end
  end
end