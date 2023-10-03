require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    # it { should validate_presence_of :token }
    # it { should validate_presence_of :google_id }
    it { should validate_presence_of :password }
  end

  describe "unit testing" do
    it "creates or updates itself from an oauth hash" do
      auth_info = {
        provider: "google",
        uid: "12345678910",
        info: {
          email: "dwilson23@turing.edu",
          first_name: "Dani",
          last_name: "Wilson"
        },
        credentials: {
          token: "abcdefg12345",
          refresh_token: "12345abcdefg"
        }
      }
      user = User.from_google_auth(auth_info)
      new_user = User.first
      # require 'pry'; binding.pry

      expect(new_user.google_id).to eq("12345678910")
      expect(new_user.email).to eq("dwilson23@turing.edu")
      expect(new_user.first_name).to eq("Dani")
      expect(new_user.last_name).to eq("Wilson")
      expect(new_user.token).to eq("abcdefg12345")
      expect(new_user.refresh_token).to eq("12345abcdefg")
    end
  end
end