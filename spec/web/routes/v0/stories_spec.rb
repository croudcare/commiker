require 'spec_helper'

describe '/api/v0/stories' do

  context 'with an authorized user_id #1' do

    before(:each) do
      @user = create :omagad_user
    end

    context 'post /api/v0/stories/:id/add_story_interaction' do

      def make_the_call(id, params = {}, headers = {})
        headers.merge!(session_headers)

        post "/api/v0/stories/#{id}/add_story_interaction", params, headers
      end

      before(:each) do
        sprint = create :sprint
        user = create :iron_man_user

        post('/api/v0/stories/bulk_create', {
          sprint_id: sprint.id,
          user_slack_uid: user.slack_uid,
          pivotal_ids: ['94839248']
        }, session_headers)

        @stories = last_response_json['created_stories']
      end

      it 'should return error for missing required params 1' do
        make_the_call(@stories[0]['id'])

        expect_bad_request_response
      end

      it 'should return error for missing required params 2' do
        make_the_call(@stories[0]['id'], {
          story_interaction: {
            a: 1
          }
        })

        expect_bad_request_response
      end

      it 'should return unprocessable_entity invalid completion_percentage param 1' do
        make_the_call(@stories[0]['id'], {
          story_interaction: {
            completion_percentage: "two"
          }
        })

        expect_unprocessable_response
      end

      it 'should return unprocessable_entity invalid completion_percentage param 2' do
        make_the_call(@stories[0]['id'], {
          story_interaction: {
            completion_percentage: 120
          }
        })

        expect_unprocessable_response
      end

      it 'should return story not found' do
        make_the_call(25)

        expect_not_found_response
      end

      it 'should create story interaction' do
        make_the_call(@stories[0]['id'], {
          story_interaction: {
            completion_percentage: 20
          }
        })

        expect_ok_response

        expect(last_response_json['story_interactions'].length).to eq(1)
        expect(last_response_json['story_interactions'][0]['completion_percentage']).to eq(20)
        expect(last_response_json['story_interactions'][0]['obs']).to be_nil
        expect(last_response_json['story_interactions'][0]['interacted_at']).not_to be_nil
      end

      it 'should create story interaction with obs' do
        make_the_call(@stories[0]['id'], {
          story_interaction: {
            completion_percentage: 40,
            obs: 'its all ok'
          }
        })

        expect_ok_response
        expect(last_response_json['story_interactions'].length).to eq(1)
        expect(last_response_json['story_interactions'][0]['completion_percentage']).to eq(40)
        expect(last_response_json['story_interactions'][0]['obs']).to eq('its all ok')
        expect(last_response_json['story_interactions'][0]['interacted_at']).not_to be_nil
      end

      it 'should create multiple story interactions' do
        make_the_call(@stories[0]['id'], {
          story_interaction: {
            completion_percentage: 20
          }
        })

        make_the_call(@stories[0]['id'], {
          story_interaction: {
            completion_percentage: 40
          }
        })

        make_the_call(@stories[0]['id'], {
          story_interaction: {
            completion_percentage: 50
          }
        })

        expect(last_response_json['story_interactions'].length).to eq(3)
      end

    end

    context 'post /api/v0/stories/bulk_create' do

      def make_the_call(params = {}, headers = {})
        headers.merge!(session_headers)

        post '/api/v0/stories/bulk_create', params, headers
      end

      context 'with error' do

        before(:each) do
          @sprint = create :sprint_one
          @user = @sprint.users.first
        end

        it 'should return bad request for missing required params' do
          make_the_call \
            sprint_id: @sprint.id,
            user_slack_uid: @user.slack_uid

          expect_bad_request_response
        end

        it 'should return bad request for invalid pivotal_ids' do
          make_the_call \
            sprint_id: @sprint.id,
            user_slack_uid: @user.slack_uid,
            pivotal_ids: []

          expect_bad_request_response
        end

        it 'should return unprocessable_entity for invalid pivotal_ids values' do
          make_the_call \
            sprint_id: @sprint.id,
            user_slack_uid: @user.slack_uid,
            pivotal_ids: ['invalid']

          expect_ok_response
          expect(last_response_json['invalid_stories'][0]['pivotal_id']).to \
            eq('invalid')
        end

        it 'should return unprocessable_entity for one invalid pivotal_ids values ' \
           'and rollback stories already created' do

          make_the_call \
            sprint_id: @sprint.id,
            user_slack_uid: @user.slack_uid,
            pivotal_ids: ['94839248', 'invalid']

          expect_ok_response
          expect(last_response_json['created_stories'][0]['pivotal_id']).to \
            eq(94839248)
          expect(last_response_json['invalid_stories'][0]['pivotal_id']).to \
            eq('invalid')
          expect(Commiker::V0::Story.count).to eq(1)
        end

        it 'should return unprocessable_entity for duplicated story' do
          make_the_call \
            sprint_id: @sprint.id,
            user_slack_uid: @user.slack_uid,
            pivotal_ids: ['94839248']

          expect_ok_response
          expect(last_response_json['invalid_stories'].length).to \
            eq(0)
          expect(last_response_json['duplicated_stories'].length).to \
            eq(0)
          expect(last_response_json['created_stories'][0]['pivotal_id']).to \
            eq(94839248)

          make_the_call \
            sprint_id: @sprint.id,
            user_slack_uid: @user.slack_uid,
            pivotal_ids: ['94839248']

          expect(last_response_json['invalid_stories'].length).to \
            eq(0)
          expect(last_response_json['duplicated_stories'][0]['pivotal_id']).to \
            eq(94839248)
          expect(last_response_json['created_stories'].length).to \
            eq(0)

          expect_ok_response
          expect(Commiker::V0::Story.count).to eq(1)
          expect(@sprint.users.count).to eq(3)
          expect(@sprint.users.first.slack_uid).to eq(@user.slack_uid)
        end

      end

      context 'without error' do

        before(:each) do
          @sprint = create :sprint
          @omagad = create :omagad_user
          @iron_man = create :iron_man_user
          @thor_man = create :thor_user
        end

        it 'should return created for adding stories to sprint' do
          make_the_call \
            sprint_id: @sprint.id,
            user_slack_uid: @omagad.slack_uid,
            pivotal_ids: ['94839248']

          expect_ok_response
          expect(last_response_json['created_stories'].length).to eq(1)
          expect(last_response_json['created_stories'][0]['sprint_id']).to eq(@sprint.id)
          expect(last_response_json['created_stories'][0]['user_id']).to eq(@omagad.id)
          expect(last_response_json['created_stories'][0]['user']['slack_uid']).to eq(@omagad.slack_uid)
          expect(last_response_json['created_stories'][0]['pivotal_id']).to eq(94839248)
          expect(Commiker::V0::Story.count).to eq(1)
        end

        it 'should return multiple stories with from multiple users' do
          make_the_call \
            sprint_id: @sprint.id,
            user_slack_uid: @iron_man.slack_uid,
            pivotal_ids: [
              '94839248',
              '97204220'
            ]

          expect_ok_response
          expect(last_response_json['created_stories'].length).to eq(2)

          make_the_call \
            sprint_id: @sprint.id,
            user_slack_uid: @thor_man.slack_uid,
            pivotal_ids: [
              '93796298'
            ]

          expect_ok_response

          expect(@sprint.users.count).to eq(2)
          expect(@sprint.stories.count).to eq(3)
        end

      end

    end

  end
end
