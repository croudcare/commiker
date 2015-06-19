module Commiker
  module V0
    module UseCases
      module Sprints
        module Create

          class ParseParams < UseCaseBase

            context_reader :sprint_attributes

            def perform
              if sprint_attributes.nil?
                failure!(:bad_request, 'missing required params for sprint')
                return
              end

              if "#{sprint_attributes['started_at']}".length == 0
                failure!(:bad_request, 'missing required param started_at')
                return
              end

              if "#{sprint_attributes['ended_at']}".length == 0
                failure!(:bad_request, 'missing required param ended_at')
                return
              end

              if !sprint_attributes['users'] ||
                  sprint_attributes['users'].length == 0
                failure!(:bad_request, 'missing required param users')
                return
              else
                users_attrs = sprint_attributes.delete('users')

                sprint_attributes['users'] = users_attrs.map do |user|
                  UseCases::Users::FindOne.perform(id: user[:id]).user
                end
              end

              # start_bot ?
              ctx.start_bot = "#{sprint_attributes[:start_bot]}" == 'true'
              sprint_attributes.delete('start_bot')

              # inits
              started_at = \
                sprint_attributes['started_at'].to_time.beginning_of_day.utc

              ended_at = \
                sprint_attributes['ended_at'].to_time.end_of_day.utc

              # validations
              if started_at > ended_at
                failure!(:unprocessable_entity, 'started_at later than ended_at')
                return
              end
            end

          end

        end
      end
    end
  end
end
