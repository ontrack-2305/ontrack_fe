module OmniauthModule
  def stub_omniauth
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: "google",
      uid: "109703219226180090006",
      info: {
        email: "ontrack2035@gmail.com",
        first_name: "OnTrack",
        last_name: "2305"
      },
      credentials: {
        token: "ya29.a0AfB_byCNHgjn9Gu4KltIuLD1vjAYXB5YOcj-NPCwP0RR5Hsb2KAxXgkveYKAcY9_m95PRV8jBUmXWwD5ovg1EPO3A2Xp_l9sg3utD8I3ZALq7nbWTWCE8PxFtYIPRFcNZoB21adV0C8O1PeUR4sVSvS775PgM1C_fAVzaCgYKAVoSARISFQGOcNnCKVFlBR4mPYO0Ce44pZRiFA0171",
        refresh_token: "1//06HWeel0lEDXYCgYIARAAGAYSNwF-L9IrcbikE0Ws2k9U6XOO-6D1nYqqAFLBTufTYrAgaEOB0vZM4t6bY7hpHRPtbpm-Y6R5jjg"
      }
    })
  end

  def stub_invalid_user
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: "google",
      uid: "12345678910",
      info: {
        first_name: "Invalid",
        last_name: "User"
      },
      credentials: {
      }
    })
  end
end