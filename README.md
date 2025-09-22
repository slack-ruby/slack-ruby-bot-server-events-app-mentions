Slack Ruby Bot Server Events App Mentions
=========================================

[![Gem Version](https://badge.fury.io/rb/slack-ruby-bot-server-events-app-mentions.svg)](https://badge.fury.io/rb/slack-ruby-bot-server-events-app-mentions)
[![lint](https://github.com/slack-ruby/slack-ruby-bot-server-events-app-mentions/actions/workflows/rubocop.yml/badge.svg)](https://github.com/slack-ruby/slack-ruby-bot-server-events-app-mentions/actions/workflows/rubocop.yml)
[![test with mongodb](https://github.com/slack-ruby/slack-ruby-bot-server-events-app-mentions/actions/workflows/test-mongodb.yml/badge.svg)](https://github.com/slack-ruby/slack-ruby-bot-server-events-app-mentions/actions/workflows/test-mongodb.yml)
[![test with postgresql](https://github.com/slack-ruby/slack-ruby-bot-server-events-app-mentions/actions/workflows/test-postgresql.yml/badge.svg)](https://github.com/slack-ruby/slack-ruby-bot-server-events-app-mentions/actions/workflows/test-postgresql.yml)

An extension to [slack-ruby-bot-server-events](https://github.com/slack-ruby/slack-ruby-bot-server-events) that makes it easier to handle [app mentions](https://api.slack.com/events/app_mention) - message events that directly mention your bot user.

### Sample

See [slack-ruby/slack-ruby-bot-server-events-app-mentions-sample](https://github.com/slack-ruby/slack-ruby-bot-server-events-app-mentions-sample) for a working sample.

### Usage

#### Gemfile

Add 'slack-ruby-bot-server-events-app-mentions' to Gemfile.

```ruby
gem 'slack-ruby-bot-server-events-app-mentions'
```

#### Configure OAuth Scopes

The [`app_mentions:read`](https://api.slack.com/scopes/app_mentions:read) OAuth scope is required to receive mentions in channels and [`im:history`](https://api.slack.com/scopes/im:history) to receive direct messages.

```ruby
SlackRubyBotServer.configure do |config|
  config.oauth_version = :v2
  config.oauth_scope = ['app_mentions:read', 'im:history']
end
```

#### Implement Mentions

Define a `mention` and implement a `call` class method that takes event data that has been extended with `team` and a regular expression `match` object.

```ruby
class Ping < SlackRubyBotServer::Events::AppMentions::Mention
  mention 'ping'

  def self.call(data)
    client = Slack::Web::Client.new(token: data.team.token)
    client.chat_postMessage(channel: data.channel, text: 'pong')
  end
end
```

Mentions can be free-formed regular expressions.

```ruby
class PingWithNumber < SlackRubyBotServer::Events::AppMentions::Mention
  mention(/ping[[:space:]]+(?<number>[[:digit:]]+)$/)

  def self.call(data)
    client = Slack::Web::Client.new(token: data.team.token)
    client.chat_postMessage(channel: data.channel, text: "pong #{data.match['number']}")
  end
end
```

#### Configure Handlers

By default this library will attempt to match any mention that inherits from `SlackRubyBotServer::Events::AppMentions::Mention` in the order of class loading. You can also configure the list of handlers.

```ruby
SlackRubyBotServer::Events::AppMentions.configure do |config|
  config.handlers = [ Ping, Ring ]
end
```

### Copyright & License

Copyright [Daniel Doubrovkine](http://code.dblock.org) and Contributors, 2020

[MIT License](LICENSE)
