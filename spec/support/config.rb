# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    SlackRubyBotServer::Events::AppMentions::Config.reset!
    @handlers = SlackRubyBotServer::Events::AppMentions::Mention.handlers
  end

  config.after do
    SlackRubyBotServer::Events::AppMentions::Mention.handlers = @handlers
  end
end
