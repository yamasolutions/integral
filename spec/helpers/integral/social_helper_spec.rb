require 'rails_helper'

module Integral
  module Backend
    describe SocialHelper do
      let(:url) { 'https:yamasolutions.com' }
      let(:message) { 'My unique message' }

      describe '#twitter_share_url' do
        let(:share_url) { 'https://twitter.com/intent/tweet/?url=http%3A%2F%2Ftest.host' }
        let(:share_url_message) { 'https://twitter.com/intent/tweet/?url=http%3A%2F%2Ftest.host&amp;text=My+unique+message' }
        let(:share_url_custom) { 'https://twitter.com/intent/tweet/?url=https%3Ayamasolutions.com' }
        let(:share_url_and_message) { 'https://twitter.com/intent/tweet/?url=https%3Ayamasolutions.com&amp;text=My+unique+message' }

        context 'when no options are provided' do
          it 'returns default twitter share url' do
            expect(helper.twitter_share_url).to eq share_url
          end
        end

        context 'when a message is provided' do
          it 'returns twitter share url with a message' do
            expect(helper.twitter_share_url(message: message)).to eq share_url_message
          end
        end

        context 'when a URL is provided' do
          it 'returns twitter share url with a custom url' do
            expect(helper.twitter_share_url(url: url)).to eq share_url_custom
          end
        end

        context 'when a URL & message is provided' do
          it 'returns twitter share url with a message & custom url' do
            expect(helper.twitter_share_url(url: url, message: message)).to eq share_url_and_message
          end
        end
      end

      describe '#linkedin_share_url' do
        let(:share_url) { 'https://www.linkedin.com/shareArticle?mini=true&amp;url=http%3A%2F%2Ftest.host' }
        let(:share_url_message) { 'https://www.linkedin.com/shareArticle?mini=true&amp;url=http%3A%2F%2Ftest.host&amp;title=My+unique+message' }
        let(:share_url_custom) { 'https://www.linkedin.com/shareArticle?mini=true&amp;url=https%3Ayamasolutions.com' }
        let(:share_url_and_message) { 'https://www.linkedin.com/shareArticle?mini=true&amp;url=https%3Ayamasolutions.com&amp;title=My+unique+message' }

        context 'when no options are provided' do
          it 'returns default share url' do
            expect(helper.linkedin_share_url).to eq share_url
          end
        end

        context 'when a message is provided' do
          it 'returns share url with a message' do
            expect(helper.linkedin_share_url(message: message)).to eq share_url_message
          end
        end

        context 'when a URL is provided' do
          it 'returns share url with a custom url' do
            expect(helper.linkedin_share_url(url: url)).to eq share_url_custom
          end
        end

        context 'when a URL & message is provided' do
          it 'returns share url with a message & custom url' do
            expect(helper.linkedin_share_url(url: url, message: message)).to eq share_url_and_message
          end
        end
      end

      describe '#facebook_share_url' do
        let(:share_url) { 'https://facebook.com/sharer/sharer.php?u=http%3A%2F%2Ftest.host' }
        let(:share_url_custom) { 'https://facebook.com/sharer/sharer.php?u=https%3Ayamasolutions.com' }

        context 'when no options are provided' do
          it 'returns default share url' do
            expect(helper.facebook_share_url).to eq share_url
          end
        end

        context 'when a URL is provided' do
          it 'returns share url with a custom url' do
            expect(helper.facebook_share_url(url: url)).to eq share_url_custom
          end
        end
      end
    end
  end
end
