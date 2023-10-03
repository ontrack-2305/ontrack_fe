class User < ApplicationRecord
  validates_presence_of :first_name, :last_name
  validates :email, uniqueness: true, presence: true
  validates_presence_of :password
  has_secure_password
  # validates_presence_of :google_id
  # validates_presence_of :token
  # validates_presence_of :google_id, unless: -> { password.present? }
  # validates_presence_of :token, unless: -> { password.present? }

  validate do |user|
    user.errors.add(:base, "Invalid Credentials") if user.email.blank?
  end

  def self.from_google_auth(auth_info)
    find_or_create_by(google_id: auth_info[:uid]) do |user|
      user.google_id = auth_info[:uid]
      user.email = auth_info[:info][:email]
      user.first_name = auth_info[:info][:first_name]
      user.last_name = auth_info[:info][:last_name]
      user.token = auth_info[:credentials][:token]
      user.refresh_token = auth_info[:credentials][:refresh_token]
    end
  end

  # def self.from_google_auth(auth)
  #   user = User.find_by(google_id: auth[:uid]) || User.new
  #   user.attributes = {
  #     google_id: auth[:uid],
  #     email: auth[:info][:email],
  #     first_name: auth[:info][:first_name],
  #     last_name: auth[:info][:last_name],
  #     token: auth[:credentials][:token],
  #     refresh_token: auth[:credentials][:refresh_token]
  #   }
  #   if user.save
  #     user
  #   else
  #     user
  #   end
  # end
end