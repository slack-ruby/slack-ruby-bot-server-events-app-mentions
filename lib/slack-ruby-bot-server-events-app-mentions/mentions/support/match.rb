# frozen_string_literal: true

module SlackRubyBotServer
  module Events
    module AppMentions
      module Support
        class Match
          extend Forwardable

          delegate MatchData.public_instance_methods(false) => :@match_data

          def initialize(match_data)
            raise ArgumentError, 'match_data should be a type of MatchData' unless match_data.is_a? MatchData

            @match_data = match_data
          end
        end
      end
    end
  end
end
