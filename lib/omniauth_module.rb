module OmniauthModule
  def stub_omniauth
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
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
    })
  end
end