Slack Ruby Bot Server Events App Mentions
=========================================

[![Gem Version](https://badge.fury.io/rb/slack-ruby-bot-server-events-app-mentions.svg)](https://badge.fury.io/rb/slack-ruby-bot-server-events-app-mentions)
[![Build Status](https://travis-ci.org/slack-ruby/slack-ruby-bot-server-events-app-mentions.svg?branch=master)](https://travis-ci.org/slack-ruby/slack-ruby-bot-server-events-app-mentions)

An extension to [slack-ruby-bot-server-events](https://github.com/slack-ruby/slack-ruby-bot-server-events) that makes it easier to handle [app mentions](https://api.slack.com/events/app_mention) - message events that directly mention your bot user.

### Sample

See [slack-ruby/slack-ruby-bot-server-events-app-mentions-sample](https://github.com/slack-ruby/slack-ruby-bot-server-events-app-mentions-sample) for a working sample.

### Usage

#### Gemfile

Add 'slack-ruby-bot-server-events-app-mentions' to Gemfile.

```ruby
gem 'slack-ruby-bot-server-events-app-mentions'
```

#### Configure

The [`app_mentions:read`](https://api.slack.com/scopes/app_mentions:read) OAuth scope is required to receive mentions in channels and [`im:history`](https://api.slack.com/scopes/im:history) to receive direct messages.

```ruby
SlackRubyBotServer.configure do |config|
  config.oauth_version = :v2
  config.oauth_scope = ['app_mentions:read', 'im:history']
end
```

#### Implement Mentions

```ruby
class Ping < SlackRubyBotServer::Events::AppMentions::Base
  mention 'ping'

  def self.call(data, match)
    client = Slack::Web::Client.new(token: data.team.token)
    client.chat_postMessage(channel: data.channel, text: 'pong')
  end
end
```

### Copyright & License

Copyright [Daniel Doubrovkine](http://code.dblock.org) and Contributors, 2020

[MIT License](LICENSE)
