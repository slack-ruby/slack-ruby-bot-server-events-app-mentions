# frozen_string_literal: true

SlackRubyBotServer::Events.configure do |config|
  config.on :event, 'event_callback', 'app_mention' do |event|
    data = event['event']
    next unless data

    team = Team.where(team_id: event['team_id']).first
    next unless team

    bot_regexp = Regexp.new("^\<\@#{team.bot_user_id}\>[[:space:]]*")

    data = Slack::Messages::Message.new(data).merge(
      text: data['text'].gsub(bot_regexp, ''),
      team: team
    )

    SlackRubyBotServer::Events::AppMentions.config.handlers.detect { |c| c.invoke(data) }
  end

  config.on :event, 'event_callback', 'message' do |event|
    data = event['event']
    next unless data

    # direct message only
    next unless data['channel_type'] == 'im'

    team = Team.where(team_id: event['team_id']).first
    next unless team

    data = Slack::Messages::Message.new(data).merge(team: team)

    SlackRubyBotServer::Events::AppMentions.config.handlers.detect { |c| c.invoke(data) }
  end
end
