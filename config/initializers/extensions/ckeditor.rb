module Ckeditor
  # Patch CKEditor to add populate with demo content button
  TextArea.class_eval do
    def render(input)
      render_populate_button = ck_options['example_content'].nil? ? true : ck_options['example_content']

      output_buffer << input
      output_buffer << javascript_tag(Utils.js_replace(options['id'], ck_options))
      output_buffer << populate_button if render_populate_button
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
  end
end

