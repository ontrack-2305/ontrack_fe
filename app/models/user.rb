class User < ApplicationRecord
  validates_presence_of :first_name, :last_name, :email, :token, :refresh_token, :google_id

  def self.update_or_create(auth)
    user = User.find_by(google_id: auth[:uid]) || User.new
    user.attributes = {
      google_id: auth[:uid],
      email: auth[:info][:email],
      first_name: auth[:info][:first_name],
      last_name: auth[:info][:last_name],
      token: auth[:credentials][:token],
      refresh_token: auth[:credentials][:refresh_token]
    }
    user.save!
    user
  end
end