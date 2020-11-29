# frozen_string_literal: true

require_relative 'support/match'

module SlackRubyBotServer
  module Events
    module AppMentions
      class Base
        include SlackRubyBotServer::Loggable

        class << self
          attr_accessor :mention_classes

          def inherited(subclass)
            SlackRubyBotServer::Events::AppMentions::Base.mention_classes ||= []
            SlackRubyBotServer::Events::AppMentions::Base.mention_classes << subclass
          end

          def mention(*values, &block)
            values = values.map { |value| value.is_a?(Regexp) ? value.source : Regexp.escape(value) }.join('|')
            match Regexp.new("(?<mention>#{values})([[:space:]]+(?<expression>.*)|)$", Regexp::IGNORECASE | Regexp::MULTILINE), &block
          end

          def invoke(data)
            finalize_routes!

            routes.each_pair do |route, options|
              match = route.match(data.text)
              next unless match

              call_mention(data, Support::Match.new(match), options[:block])
              return true
            end
            false
          end

          def match(match, &block)
            routes[match] = { block: block }
          end

          def routes
            @routes ||= ActiveSupport::OrderedHash.new
          end

          private

          def mention_name_from_class
            name ? name.split(':').last.downcase : object_id.to_s
          end

          def call_mention(data, match, block)
            if block
              block.call(data, match)
            elsif respond_to?(:call)
              send(:call, data, match)
            else
              raise NotImplementedError, data.text
            end
          end

          def finalize_routes!
            return if routes&.any?

            mention mention_name_from_class
          end
        end
      end
    end
  end
end
