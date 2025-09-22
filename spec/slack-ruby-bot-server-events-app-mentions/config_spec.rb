# frozen_string_literal: true

require 'spec_helper'

describe SlackRubyBotServer::Events::AppMentions::Config do
  %i[
    handlers
  ].each do |k|
    context "with #{k} set" do
      before do
        SlackRubyBotServer::Events::AppMentions.configure do |config|
          config.send("#{k}=", 'set')
        end
      end

      it "sets and returns #{k}" do
        expect(SlackRubyBotServer::Events::AppMentions.config.send(k)).to eq 'set'
      end
    end
  end
end
