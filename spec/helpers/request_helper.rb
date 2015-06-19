module RequestHelper

  def last_response_json
    JSON.parse(last_response.body)
  end

  def expect_ok_response
    expect(last_response.status).to be 200
  end

  def expect_created_response
    expect(last_response.status).to be 201
  end

  def expect_accepted_response
    expect(last_response.status).to be 202
  end

  def expect_no_content_response
    expect(last_response.status).to be 204
  end

  def expect_not_found_response
    expect(last_response.status).to be 404
  end

  def expect_bad_request_response
    expect(last_response.status).to be 400
  end

  def expect_method_not_allowed_response
    expect(last_response.status).to be 405
  end

  def expect_unprocessable_response
    expect(last_response.status).to be 422
  end

end
