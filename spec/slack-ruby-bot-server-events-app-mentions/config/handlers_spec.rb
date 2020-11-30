# frozen_string_literal: true

require 'spec_helper'

describe SlackRubyBotServer::Events::AppMentions do
  let!(:team) { Fabricate(:team) }

  let(:message) do
    Slack::Messages::Message.new(
      'team_id' => team.team_id,
      'event' => {
        'channel' => 'channel',
        'text' => "<@#{team.bot_user_id}> ping"
      }
    )
  end

  let!(:one) do
    Class.new(SlackRubyBotServer::Events::AppMentions::Mention) do
      mention 'ping' do |data|
        client = Slack::Web::Client.new(token: data.team.token)
        client.chat_postMessage(text: 'one', channel: data.channel)
      end
    end
  end

  let!(:two) do
    Class.new(SlackRubyBotServer::Events::AppMentions::Mention) do
      mention 'ping' do |data|
        client = Slack::Web::Client.new(token: data.team.token)
        client.chat_postMessage(text: 'two', channel: data.channel)
      end
    end
  end

  context 'one' do
    before do
      SlackRubyBotServer::Events::AppMentions.configure do |config|
        config.handlers = [one]
      end
    end

    it 'only invokes one registered mention' do
      expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).with(text: 'one', channel: 'channel')
      SlackRubyBotServer::Events.config.run_callbacks(:event, %w[event_callback app_mention], message)
    end
  end

  context 'two' do
    before do
      SlackRubyBotServer::Events::AppMentions.configure do |config|
        config.handlers = [two]
      end
    end

    it 'only invokes two registered mention' do
      expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).with(text: 'two', channel: 'channel')
      SlackRubyBotServer::Events.config.run_callbacks(:event, %w[event_callback app_mention], message)
    end
  end

  context 'both' do
    context 'one, two' do
      before do
        SlackRubyBotServer::Events::AppMentions.configure do |config|
          config.handlers = [one, two]
        end
      end

      it 'only invokes first registered mention' do
        expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).with(text: 'one', channel: 'channel')
        SlackRubyBotServer::Events.config.run_callbacks(:event, %w[event_callback app_mention], message)
      end
    end

    context 'two, one' do
      before do
        SlackRubyBotServer::Events::AppMentions.configure do |config|
          config.handlers = [two, one]
        end
      end

      it 'only invokes first registered mention' do
        expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).with(text: 'two', channel: 'channel')
        SlackRubyBotServer::Events.config.run_callbacks(:event, %w[event_callback app_mention], message)
      end
    end
  end
end
