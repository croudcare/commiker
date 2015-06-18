module Commiker
  module V0
    module UseCases
      module Sprints
        module Create

          class ParseParams < UseCaseBase

            context_reader :sprint_attributes

            def perform
              if sprint_attributes.nil?
                ctx.errors.push(:sprint, 'missing required params for sprint')
                failure!(:bad_request)
                return
              end

              if !"#{sprint_attributes[:started_at]}".length == 0
                ctx.errors.push(:sprint, 'missing required param started_at')
                failure!(:bad_request)
              end

              if !"#{sprint_attributes[:ended_at]}".length == 0
                ctx.errors.push(:sprint, 'missing required param ended_at')
                failure!(:bad_request)
              end

              if sprint_attributes[:sprints_users].length == 0
                ctx.errors.push(:sprint, 'missing users')
                failure!(:bad_request)
              else
                users_attrs = sprint_attributes.delete('sprints_users')

                sprint_attributes[:users] = users_attrs.map do |user|
                  Users::FindOne.perform(id: user[:id]).user
                end
              end

              # inits
              started_at = sprint_attributes[:started_at].to_time.beginning_of_day.utc
              ended_at = sprint_attributes[:ended_at].to_time.end_of_day.utc

              # validations
              if started_at > ended_at
                ctx.errors.push(:sprint, 'started_at later than ended_at')
                ctx.errors.push(:sprint, 'started_at later than ended_at')
              end
            end

          end

        end
      end
    end
  end
end
