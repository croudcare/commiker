require 'spec_helper'

describe '/api/v0/stories' do

  context 'with an authorized user_id #1' do

    before(:each) do
      @user = create :auth_user
      stub_pivotal_request('90895614')
      stub_pivotal_request('94839248')
      stub_pivotal_request('97204220')
      stub_pivotal_request('93796298')
      stub_invalid_pivotal_request
    end

    context 'posts /api/v0/stories' do

      before(:each) do
        @sprint = create :sprint
        @sprint.update_column(:active, true)

        post('/api/v0/stories/bulk_create', {
          sprint_id: @sprint.id,
          user_slack_uid: @user.slack_uid,
          pivotal_ids: ['94839248']
        }, session_headers(@user.id))

        @stories = last_response_json['created_stories']
      end

      def make_the_call(params = {}, headers = {})
        headers.merge!(session_headers(@user.id))

        post "/api/v0/stories", params, headers
      end

      it 'should return missing params 1' do
        make_the_call

        expect_bad_request_response
      end

      it 'should return missing params 2' do
        make_the_call \
          story: {
            sprint_id: @sprint.id,
            user_id: @user.id
          }

        expect_bad_request_response
      end

      it 'should return invalid sprint, not active' do
        make_the_call \
          story: {
            sprint_id: 23,
            pivotal_id: 123,
            description: "asd"
          }
          # user_id: @user.id, goes in auth token

        expect_unprocessable_response
        expect(last_response_json['errors']['unprocessable_entity'][0]).to \
          eq('could not find an active sprint with the give sprint_id')
      end

      it 'should create a story' do
        make_the_call \
          story: {
            sprint_id: @sprint.id,
            pivotal_id: 123,
            description: "123description"
          }

        expect_created_response
      end

      it 'should create a story' do
        make_the_call \
          story: {
            sprint_id: @sprint.id,
            pivotal_id: "sasdasdads",
            description: "123description"
          }

        expect(last_response_json['errors']['unprocessable_entity'][0]).to \
          eq('invalid pivotal id, needs to be a number')
        expect_unprocessable_response
      end

    end

    context 'delete /api/v0/stories/:id' do

      def make_the_call(id, params = {}, headers = {})
        headers.merge!(session_headers(@user.id))

        delete "/api/v0/stories/#{id}", params, headers
      end

      before(:each) do
        @sprint = create :sprint
        user = create :iron_man_user

        post('/api/v0/stories/bulk_create', {
          sprint_id: @sprint.id,
          user_slack_uid: user.slack_uid,
          pivotal_ids: ['94839248']
        }, session_headers(@user.id))

        @stories = last_response_json['created_stories']
      end

      it 'should return not found for invalid story' do
        make_the_call 123

        expect_not_found_response
      end

      it 'should soft delete story' do
        story_id = @stories[0]['id']

        make_the_call story_id

        expect_accepted_response
        expect(Commiker::V0::Story.with_deleted.find(story_id)).not_to be_nil
      end

    end

    context 'post /api/v0/stories/:id/add_story_interaction' do

      def make_the_call(id, params = {}, headers = {})
        headers.merge!(session_headers(@user.id))

        post "/api/v0/stories/#{id}/add_story_interaction", params, headers
      end

      before(:each) do
        sprint = create :sprint
        user = create :iron_man_user

        post('/api/v0/stories/bulk_create', {
          sprint_id: sprint.id,
          user_slack_uid: user.slack_uid,
          pivotal_ids: ['94839248']
        }, session_headers(@user.id))

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

      context 'with multiple stories' do

        before(:each) do
          sprint = create :sprint
          user = create :iron_man_user

          post('/api/v0/stories/bulk_create', {
            sprint_id: sprint.id,
            user_slack_uid: user.slack_uid,
            pivotal_ids: ['94839248', '97204220', '93796298']
          }, session_headers(@user.id))

          @stories = last_response_json['created_stories']
        end

        it 'should create multiple stories and story interactions and return completion_percentage' do
          make_the_call(@stories[0]['id'], {
            story_interaction: {
              completion_percentage: 20
            }
          })

          make_the_call(@stories[1]['id'], {
            story_interaction: {
              completion_percentage: 80
            }
          })

          make_the_call(@stories[2]['id'], {
            story_interaction: {
              completion_percentage: 34
            }
          })

          get \
            "/api/v0/sprints/#{last_response_json['sprint_id']}",
            {},
            session_headers(@user.id)

          total = (@stories.count * 100)
          completion_sum = [20, 80, 34].sum
          expected_percentage = (completion_sum * 100 / total)

          expect(last_response_json['completion_percentage']).to eq(expected_percentage)
        end

      end

    end

    context 'post /api/v0/stories/bulk_create' do

      def make_the_call(params = {}, headers = {})
        headers.merge!(session_headers(@user.id))

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

        it 'should return unprocessable_entity for invalid slack_uid' do
          make_the_call \
            sprint_id: @sprint.id,
            user_slack_uid: 'slack_not_uid',
            pivotal_ids: ['123']

          expect_unprocessable_response
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
