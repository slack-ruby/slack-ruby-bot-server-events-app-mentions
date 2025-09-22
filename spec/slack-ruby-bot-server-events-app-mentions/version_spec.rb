# frozen_string_literal: true

require 'spec_helper'

describe SlackRubyBotServer::Events::AppMentions do
  it 'has a version' do
    expect(SlackRubyBotServer::Events::AppMentions::VERSION).not_to be_nil
  end
end
