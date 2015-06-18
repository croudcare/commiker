module Commiker
  module V0
    module UseCases
      module Sprints
        module Create

          class StartBOT < UseCaseBase

            context_reader :sprint

            def perform
              return unless ctx.start_bot

              cli = SlackBOTCli.new \
                slack_token: Configs['SLACK_HOOK_TOKEN'],
                sprint_id: sprint.id

              cli.start_sprint
            end

          end

          class SlackBOTCli

            include HTTParty

            base_uri 'https://pearlgems.slack.com'

            attr_reader :slack_token,
                        :sprint_id

            def initialize(options = {})
              @slack_token = options[:slack_token]
              @sprint_id = options[:sprint_id]
            end

            def start_sprint
              SlackBOTCli.post \
                "/services/hooks/slackbot?token=#{slack_token}&channel=%23general",
                { body: "start sprint #{sprint_id}" }
            end

          end

        end
      end
    end
  end
end
