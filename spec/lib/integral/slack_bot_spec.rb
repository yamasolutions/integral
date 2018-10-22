require "rails_helper"

module Integral
  describe SlackBot do
    let(:bot) { described_class.new('slack_web_hook_url') }
    let(:notifier) { double(ping: double(status: 200, body: 'HTTP body')) }
    let(:fallback) { 'some fallback message' }
    let(:pretext) { 'some random text' }
    let(:author_name) { 'some random text' }
    let(:author_icon) { 'some random text' }
    let(:author_link) { 'some random text' }
    let(:title) { 'some random text' }
    let(:title_link) { 'some random text' }
    let(:text) { 'some random text' }
    let(:image_url) { 'some random text' }

    let(:message_options) { {
      fallback: fallback,
      pretext: pretext,
      author_name: author_name,
      author_icon: author_icon,
      author_link: author_link,
      title: title,
      title_link: title_link,
      text: text,
      image_url: image_url
    } }

    let(:message) { {
      "attachments" => [ {
        "fallback" => fallback,
        "color" => "#d31a5e",
        "pretext" => pretext,
        "author_name" => author_name,
        "author_link" => author_link,
        "author_icon" => author_icon,
        "title" => title,
        "title_link" => title_link,
        "text" => text,
        "image_url" => image_url
      } ]
    } }

    before do
      allow(Slack::Notifier).to receive(:new).and_return(notifier)
    end

    describe '.ping' do
      it 'pings a Slack Notifier with the correct message' do
        Integral.slack_web_hook_url = 'foobar'

        expect(notifier).to receive(:ping).with(message, {})
        described_class.ping(message: message_options)
      end
    end

    describe '#ping' do
      it 'pings a Slack Notifier with the correct message' do
        expect(notifier).to receive(:ping).with(message, {})
        bot.ping(message: message_options)
      end
    end
  end
end
