# frozen_string_literal: true

module SlackRubyBotServer
  module Events
    module AppMentions
      module Config
        extend self

        ATTRIBUTES = %i[
          handlers
        ].freeze

        attr_accessor(*Config::ATTRIBUTES - [:handlers])
        attr_writer :handlers

        def handlers
          @handlers || SlackRubyBotServer::Events::AppMentions::Mention.handlers
        end

        def reset!
          self.handlers = nil
        end
      end

      class << self
        def configure
          block_given? ? yield(Config) : Config
        end

        def config
          Config
        end
      end
    end
  end
end

SlackRubyBotServer::Events::AppMentions::Config.reset!
