# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    SlackRubyBotServer::Events::AppMentions::Config.reset!
  end
end
