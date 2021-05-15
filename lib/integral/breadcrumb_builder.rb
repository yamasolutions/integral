module Integral
  class BreadcrumbBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
    # @return [String] representing the breadcrumb
    def render
      output = ''
      output += "<nav aria-label='Breadcrumbs' role='navigation'>"
      output += "<ol class='breadcrumb'>"

      output += @elements.collect do |element|
        render_element(element)
      end.join

      output += '</ol>'
      output += '</nav>'
      output
    end

    private

    def render_element(element)
      if element.path.nil? || @context.current_page?(compute_path(element))
        @context.content_tag :li, class: 'breadcrumb-item active', 'aria-current' => "page" do
          compute_name(element)
        end
      else
        @context.content_tag :li, class: 'breadcrumb-item' do
          @context.link_to(compute_name(element), compute_path(element), element.options)
        end
      end
    end
  end
end
