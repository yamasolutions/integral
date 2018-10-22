# Handle Google Analytics behaviour
class this.GoogleAnalytics
  # Sets a read event for users viewing a page after a certain amount of seconds.
  # This is to create an adjusted bounce rate;
  # https://moz.com/blog/adjusted-bounce-rate
  @trackRead: ->
    minimumEngagementTimeInSeconds = 20

    setTimeout ( ->
      window.dataLayer = window.dataLayer || []
      dataLayer.push({ 'event': 'PageRead' })
    ), minimumEngagementTimeInSeconds * 1000

  # Set userId used by Google Analytics for User tracking
  @trackUser: ->
    window.dataLayer = window.dataLayer || []
    userid = $('body').data('user-id')
    dataLayer.push({ 'userid': userid })

  # Inform Google Tag Manager that a VirtualPageview has taken place
  @virtualPageView: ->
    window.dataLayer = window.dataLayer || []
    dataLayer.push({ 'event': 'VirtualPageview' })
