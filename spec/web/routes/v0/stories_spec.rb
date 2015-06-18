require 'spec_helper'

describe '/api/v0/stories' do

  context 'with an authorized user_id #1' do

    before(:each) do
      @user = create :omagad_user
    end

    context 'post /api/v0/stories' do

      def make_the_call(params = {}, headers = {})
        headers.merge!(session_headers)

        post '/api/v0/stories/bulk_create', params, headers
      end

      before(:each) do
        @sprint = create :sprint_one
      end

      it 'should return bad request for missing required params' do
        make_the_call \
          sprint_id: @sprint.id,
          user_id: @sprint.users.first.id

        expect_bad_request_response
      end

      it 'should return bad request for invalid pivotal_ids' do
        make_the_call \
          sprint_id: @sprint.id,
          user_id: @sprint.users.first.id,
          pivotal_ids: []

        expect_bad_request_response
      end

      it 'should return unprocessable_entity for invalid pivotal_ids values' do
        make_the_call \
          sprint_id: @sprint.id,
          user_id: @sprint.users.first.id,
          pivotal_ids: ['invalid']

        expect_unprocessable_response
      end

      it 'should return unprocessable_entity for one invalid pivotal_ids values ' \
         'and rollback stories already created' do
        make_the_call \
          sprint_id: @sprint.id,
          user_id: @sprint.users.first.id,
          pivotal_ids: ['94839248', 'invalid']

        expect_unprocessable_response
        expect(Commiker::V0::Story.count).to eq(0)
      end

      it 'should return created for adding stories do sprint' do
        make_the_call \
          sprint_id: @sprint.id,
          user_id: @sprint.users.first.id,
          pivotal_ids: ['94839248']

        expect_created_response
        expect(last_response_json['stories'].length).to eq(1)
        expect(last_response_json['stories'][0]['sprint_id']).to eq(@sprint.id)
        expect(last_response_json['stories'][0]['user_id']).to eq(@sprint.users.first.id)
        expect(last_response_json['stories'][0]['pivotal_id']).to eq(94839248)
      end

    end

  end
end
