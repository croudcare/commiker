module RequestHelper

  def stub_pivotal_request(pivotal_id)
    response = {
      kind: 'story',
      id: pivotal_id,
      name: 'description'
    }

     stub_request(:get, "https://www.pivotaltracker.com/services/v5/stories/#{pivotal_id}")
      .with(headers: { 'X-Trackertoken' => 'pivotal_test_token' })
      .to_return(status: 200, body: response.to_json)
  end

  def stub_invalid_pivotal_request
    response = {
      kind: 'error'
    }

    stub_request(:get, 'https://www.pivotaltracker.com/services/v5/stories/invalid')
      .with(headers: { 'X-Trackertoken' => 'pivotal_test_token' })
      .to_return(status: 200, body: response.to_json)
  end

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
