# frozen_string_literal: true

Bundler.require

require 'slack-ruby-bot-server/rspec'

Dir[File.join(__dir__, 'support', '**/*.rb')].sort.each do |file|
  require file
end

SlackRubyBotServer::Service.logger.level = Logger::WARN
