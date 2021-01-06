# frozen_string_literal: true

require 'spec_helper'

describe SlackRubyBotServer::Events::AppMentions do
  let!(:team) { Fabricate(:team) }

  let(:message) do
    SlackRubyBotServer::Events::Requests::Event.new(
      {
        'token' => 'fake',
        'team_id' => team.team_id,
        'event' => {
          'channel' => 'channel',
          'text' => "<@#{team.bot_user_id}> ping"
        }
      },
      nil
    )
  end

  let!(:mention) do
    Class.new(SlackRubyBotServer::Events::AppMentions::Mention) do
      mention 'ping' do |data|
        client = Slack::Web::Client.new(token: data.team.token)
        client.chat_postMessage(text: 'pong', channel: data.channel)
      end
    end
  end

  it 'registers mention' do
    expect(SlackRubyBotServer::Events::AppMentions::Mention.handlers).to include mention
  end

  it 'invokes a mention' do
    expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).with(
      text: 'pong', channel: 'channel'
    )

    SlackRubyBotServer::Events.config.run_callbacks(
      :event,
      %w[event_callback app_mention],
      message
    )
  end
end
