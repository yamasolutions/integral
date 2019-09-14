module Integral
  # Handles rendering Google Tag Manager snipper
  class GoogleTagManager
    # Render Google Tag Manager Snippet
    #
    # @return [String] GTM Container if ID has been supplied
    def self.render(container_id, type = :script)
      # TODO: - May want to add some other check for staging environments
      return '' if !container_id.present? || !Rails.env.production?

      snippet = if type == :script
                  <<-HTML
          <!-- Google Tag Manager -->
          <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
          new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
          j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
          '//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
          })(window,document,'script','dataLayer','#{container_id}');</script>
          <!-- End Google Tag Manager -->
                  HTML
                else
                  <<-HTML
          <!-- Google Tag Manager -->
          <noscript><iframe src="//www.googletagmanager.com/ns.html?id=#{container_id}"
          height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
          <!-- End Google Tag Manager -->
                  HTML
                end

      snippet.html_safe
    end
  end
end
