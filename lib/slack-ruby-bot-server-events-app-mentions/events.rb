# frozen_string_literal: true

SlackRubyBotServer::Events.configure do |config|
  config.on :event, 'event_callback', 'app_mention' do |event|
    team = Team.where(team_id: event['team_id']).first
    next unless team

    data = event['event']
    next unless data

    bot_regexp = Regexp.new("^\<\@#{team.bot_user_id}\>[[:space:]]*")

    data = Hashie::Mash.new(data)
    data.text = data.text.gsub(bot_regexp, '')
    data.team = team

    SlackRubyBotServer::Events::AppMentions::Base.mention_classes.detect { |c| c.invoke(data) }
  end
end
