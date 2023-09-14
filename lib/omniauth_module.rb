module OmniauthModule
  def stub_omniauth
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      {
        'provider' => 'google_oauth2',
        'uid' => '71',
        'info' => {
          'name' => 'Garbanzo',
          'email' => 'thegarbonz@fake.com',
          'unverified_email' => 'thegarbonz@fake.com',
          'email_verified' => true
        },
        'credentials' => {
          'token' =>
          'token',
          'expires_at' => 12,
          'expires' => true
        }
      }
    )
  end
end