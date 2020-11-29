# frozen_string_literal: true

module SlackRubyBotServer
  module Events
    module AppMentions
      module Support
        class Attrs
          attr_accessor :mention_name, :mention_desc, :mention_long_desc
          attr_reader :klass, :mentions

          def initialize(klass)
            @klass = klass
            @mentions = []
          end

          def title(title)
            self.mention_name = title
          end

          def desc(desc)
            self.mention_desc = desc
          end

          def long_desc(long_desc)
            self.mention_long_desc = long_desc
          end

          def mention(title, &block)
            @mentions << self.class.new(klass).tap do |k|
              k.title(title)
              k.instance_eval(&block)
            end
          end
        end
      end
    end
  end
end
