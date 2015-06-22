module UseCaseHelper

  def session_headers(user_id)
    {
      'HTTP_AUTHORIZATION' => "Bearer #{Rack::Jwt::Auth::AuthToken.issue_token({ user_id: user_id }, Configs["AUTHENTICATION_SECRET"])}"
    }
  end

end
