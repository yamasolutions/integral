module Integral
  # Social Helper which contains methods relating to social networking
  module SocialHelper
    # Mail link sharing
    #
    # @param [Hash] opts the options to create the share URL
    # @option opts [String] :url Supply URL if would like to share URL other than the current
    # @option opts [String] :message The message to provide a message for the tweet.
    #
    # @return [String] Twitter URL to share a page
    def mail_share_url(opts = {}, escape: true)
      page_url = opts.fetch(:url, request.original_url)
      message = opts.fetch(:message, '')

      if escape
        page_url = CGI.escape(page_url)
        message = CGI.escape(message) if message.present?
      end

      share_url = "mailto:?body=#{page_url}"
      share_url += "&subject=#{message}" if message.present?

      share_url
    end

    # Twitter social sharing
    # URL snippet built from - https://sharingbuttons.io/
    #
    # @param [Hash] opts the options to create the share URL
    # @option opts [String] :url Supply URL if would like to share URL other than the current
    # @option opts [String] :message The message to provide a message for the tweet.
    #
    # @return [String] Twitter URL to share a page
    def twitter_share_url(opts = {})
      page_url = opts.fetch(:url, request.original_url)
      message = opts.fetch(:message, '')

      page_url = CGI.escape(page_url)
      share_url = "https://twitter.com/intent/tweet/?url=#{page_url}"
      share_url += "&amp;text=#{CGI.escape(message)}" if message.present?

      share_url
    end

    # Facebook social sharing
    # URL snippet built from - https://sharingbuttons.io/
    #
    # @param [Hash] opts the options to create the share URL
    # @option opts [String] :url Supply URL if would like to share URL other than the current
    #
    # @return [String] Facebook URL to share a page
    def facebook_share_url(opts = {})
      page_url = opts.fetch(:url, request.original_url)

      page_url = CGI.escape(page_url)
      share_url = "https://facebook.com/sharer/sharer.php?u=#{page_url}"

      share_url
    end

    # Linkedin social sharing
    # URL snippet built from - https://sharingbuttons.io/
    #
    # @param [Hash] opts the options to create the share URL
    # @option opts [String] :url Supply URL if would like to share URL other than the current
    # @option opts [String] :message The message to provide a message for the tweet.
    #
    # @return [String] Linkedin URL to share a page
    def linkedin_share_url(opts = {})
      page_url = opts.fetch(:url, request.original_url)
      message = opts.fetch(:message, '')

      page_url = CGI.escape(page_url)
      share_url = "https://www.linkedin.com/shareArticle?mini=true&amp;url=#{page_url}"
      share_url += "&amp;title=#{CGI.escape(message)}" if message.present?

      share_url
    end

    # Github URL set from within Backend Settings area
    #
    # @return [String] Github URL
    def github_url
      Settings.github_url
    end

    # Twitter Profile URL set from within Backend Settings area
    #
    # @return [String] Twitter URL
    def twitter_url
      Settings.twitter_url
    end

    # Facebook Profile URL set from within Backend Settings area
    #
    # @return [String] Facebook URL
    def facebook_url
      Settings.facebook_url
    end

    # Youtube Profile URL set from within Backend Settings area
    #
    # @return [String] Youtube URL
    def youtube_url
      Settings.youtube_url
    end

    # Linkedin Profile URL set from within Backend Settings area
    #
    # @return [String] Linkedin URL
    def linkedin_url
      Settings.linkedin_url
    end

    # Instagram Profile URL set from within Backend Settings area
    #
    # @return [String] Instagram URL
    def instagram_url
      Settings.instagram_url
    end
  end
end
