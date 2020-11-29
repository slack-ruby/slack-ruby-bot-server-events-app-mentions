# frozen_string_literal: true

require 'spec_helper'

describe SlackRubyBotServer::Events::AppMentions do
  let!(:team) { Fabricate(:team) }

  let! :command do
    Class.new(SlackRubyBotServer::Events::AppMentions::Base) do
      mention 'ping' do |data, _match|
        client = Slack::Web::Client.new(token: data.team.token)
        client.chat_postMessage(text: 'pong', channel: data.channel)
      end
    end
  end

  it 'registers mention' do
    expect(SlackRubyBotServer::Events::AppMentions::Base.mention_classes).to include command
  end

  it 'invokes a mention' do
    expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage).with(
      text: 'pong', channel: 'channel'
    )

    SlackRubyBotServer::Events.config.run_callbacks(
      :event,
      %w[event_callback app_mention],
      {
        'team_id' => team.team_id,
        'event' => {
          'channel' => 'channel',
          'text' => "<@#{team.bot_user_id}> ping"
        }
      }
    )
  end
end
