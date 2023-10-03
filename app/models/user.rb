class User < ApplicationRecord
  validates_presence_of :first_name, :last_name, :google_id, :token, :email

  validate do |user|
    user.errors.add(:base, "Invalid Credentials") if user.email.blank?
  end

  def self.from_google_auth(auth_info)
    find_or_create_by(google_id: auth_info[:uid]) do |user|
      user.email = auth_info[:info][:email]
      user.first_name = auth_info[:info][:first_name]
      user.last_name = auth_info[:info][:last_name]
      user.token = auth_info[:credentials][:token]
      user.refresh_token = auth_info[:credentials][:refresh_token]
    end
  end
end