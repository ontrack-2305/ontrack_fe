class User < ApplicationRecord
  validates_presence_of :name, :email, :token, :google_id

  def self.from_omniauth(response)
    User.find_or_create_by(google_id: response[:uid]) do |u|
      u.name = response[:info][:name]
      u.email = response[:info][:email]
      u.token = response[:credentials][:token]
    end
  end
end