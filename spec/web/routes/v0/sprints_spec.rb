require 'spec_helper'

describe '/api/v0/sprints' do

  context 'with an authorized user_id #1' do

    before(:each) do
      @user = create :omagad_user
    end

    context 'get /api/v0/sprints/:id' do

      def make_the_call(id, params = {}, headers = {})
        headers.merge!(session_headers)

        get "/api/v0/sprints/#{id}", params, headers
      end

      def make_the_bulk_stories_call(params = {}, headers = {})
        headers.merge!(session_headers)

        post '/api/v0/stories/bulk_create', params, headers
      end

      before(:each) do
        @sprint_one = create :sprint_one
      end

      it 'should return not_found' do
        make_the_call 99

        expect_not_found_response
      end

      it 'should return one sprint' do
        make_the_call @sprint_one.id

        expect_ok_response
        expect(last_response_json['id']).to eq(@sprint_one.id)
        expect(last_response_json['starter_id']).to eq(@sprint_one.starter_id)
        expect(last_response_json['obs']).to eq(@sprint_one.obs)

        expect(last_response_json['started_at'].to_time.utc.iso8601).to \
          eq(@sprint_one.started_at.utc.iso8601)
        expect(last_response_json['ended_at'].to_time.utc.iso8601).to \
          eq(@sprint_one.ended_at.utc.iso8601)

        expect(last_response_json['users'].length).to eq(@sprint_one.users.count)
      end

      it 'should return sprint with stories' do
        user = @sprint_one.users.first

        make_the_bulk_stories_call \
          sprint_id: @sprint_one.id,
          user_slack_uid: user.slack_uid,
          pivotal_ids: [
            '90895614'
          ]

        expect_created_response

        make_the_call @sprint_one.id

        expect(last_response_json['users'].length).to eq(3)

        last_response_json['users'].each do |sprint_user|
          if sprint_user['id'] == user.id
            expect(sprint_user['stories'].length).to eq(1)
            expect(sprint_user['stories'][0]['pivotal_id']).to eq(90895614)
          end
        end
      end

    end

    context 'post /api/v0/sprints/' do

      def make_the_call(params = {}, headers = {})
        headers.merge!(session_headers)

        post '/api/v0/sprints/', params, headers
      end

      it 'should return bad_request for missing params 1' do
        make_the_call

        expect_bad_request_response
      end

      it 'should return bad_request for missing params 2' do
        make_the_call \
          sprint: {
            starter_id: 1,
            obs: 'this is an obs'
          }

        expect_bad_request_response
      end

      it 'should return bad_request for missing params 3' do
        make_the_call \
          sprint: {
            starter_id: 1,
            obs: 'this is an obs',
            started_at: Time.now.utc,
            ended_at: (Time.now + 7.days).utc
          }

        expect_bad_request_response
      end

      it 'should create a sprint' do
        starter_id = 1
        started_at = Time.now.utc.iso8601
        ended_at = (Time.now + 7.days).utc.iso8601
        obs = 'this is an obs'

        make_the_call \
          sprint: {
            starter_id: 1,
            obs: 'this is an obs',
            started_at: started_at,
            ended_at: ended_at,
            users: [{
              id: 1
            }]
          }

        expect_created_response
        expect(last_response_json['id']).not_to be_nil
        expect(last_response_json['starter_id']).to eq(starter_id)
        expect(last_response_json['obs']).to eq(obs)
        expect(last_response_json['started_at'].to_time.utc.iso8601).to eq(started_at)
        expect(last_response_json['ended_at'].to_time.utc.iso8601).to eq(ended_at)
      end

    end

    context 'get /api/v0/sprints' do

      def make_the_call(params = {}, headers = {})
        headers.merge!(session_headers)

        get '/api/v0/sprints/', params, headers
      end

      before(:each) do
        @sprint_one = create :sprint_one
        @sprint_two = create :sprint_two
        @sprint_three = create :sprint_three
      end

      it 'should return all stories' do
        make_the_call

        expect_ok_response
        expect(last_response_json['sprints'].length).to eq(3)
      end

      it 'should return stories paged' do
        make_the_call(page: 1, per_page: 2)

        expect_ok_response
        expect(last_response_json['sprints'].length).to eq(2)

        make_the_call(page: 2, per_page: 2)

        expect_ok_response
        expect(last_response_json['sprints'].length).to eq(1)
      end

    end

  end

end
