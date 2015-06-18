module UseCaseHelper

  def session_headers
    {
      'HTTP_AUTHORIZATION' => "Bearer #{Rack::Jwt::Auth::AuthToken.issue_token({ user_id: 1 }, Configs["AUTHENTICATION_SECRET"])}"
    }
  end

end
