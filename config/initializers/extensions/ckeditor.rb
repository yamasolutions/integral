module Ckeditor
  # Patch CKEditor to add populate with demo content button
  TextArea.class_eval do

    def initialize(template, options)
      @template = template
      @options = options.stringify_keys

      @options['class'].delete(:ckeditor)
      @options['data'] = {} if @options['data'].nil?
      @options['data']['controller'] = 'ckeditor'

      @options['ckeditor'] = @options['ckeditor'].stringify_keys || {}
      @render_example_content = @options['ckeditor']['example_content'].nil? ? true : @options['ckeditor']['example_content']

      if @options['data']['ckeditor-custom-config'].blank? && Ckeditor.js_config_url.present?
        @options['data']['ckeditor-custom-config'] = template.asset_path(Ckeditor.js_config_url)
      end

      @options['data']['ckeditor-toolbar'] = @options['ckeditor']['toolbar']
      @options['data']['ckeditor-language'] = @options['ckeditor']['language']
      @options['data']['ckeditor-body-class'] = @options['ckeditor']['body_class']
      @options['ckeditor'] = nil
    end

    def render(input)
      output_buffer << input
      output_buffer << populate_button if render_populate_button?
      output_buffer
    end

    private

    def populate_button
      add_icon = content_tag(:i, nil, class: 'fa fa-plus-circle')
      content_tag(:a,
                  add_icon + I18n.t('ckeditor.populate_editor'),
                  class: 'populate-button',
                  href: '#',
                  'data-example-content' => example_content)
    end

    def example_content
      Rails.cache.fetch("integral_ckeditor_example_content") do
        File.read(File.join(Integral::Engine.root.join('public', 'integral', 'ckeditor_demo_content.html')))
      end
    end

    def render_populate_button?
      @render_example_content
    end
  end
end
