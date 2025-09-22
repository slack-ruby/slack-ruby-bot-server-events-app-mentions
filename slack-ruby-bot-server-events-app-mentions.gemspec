# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slack-ruby-bot-server-events-app-mentions/version'

Gem::Specification.new do |spec|
  spec.name          = 'slack-ruby-bot-server-events-app-mentions'
  spec.version       = SlackRubyBotServer::Events::AppMentions::VERSION
  spec.authors       = ['Daniel Doubrovkine']
  spec.email         = ['dblock@dblock.org']

  spec.summary       = 'Adds commands to slack-ruby-bot-server-events.'
  spec.homepage      = 'https://github.com/slack-ruby/slack-ruby-bot-server-events-app-mentions'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'slack-ruby-bot-server-events'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
