# Foundation 6 builder for breadcrumbs
# :nocov:
class FoundationBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
  # @return [String] representing the breadcrumb
  def render
    output = ''
    output += "<nav aria-label='You are here:' role='navigation'>"
    output += "<ul class='breadcrumbs'>"

    output += @elements.collect do |element|
      render_element(element)
    end.join

    output += '</ul>'
    output += '</nav>'
    output
  end

  private

  def render_element(element)
    if element.path.nil? || @context.current_page?(compute_path(element))
      @context.content_tag :li do
        @context.content_tag(:span, 'Current: ', class: 'show-for-sr') +
          compute_name(element)
      end
    else
      @context.content_tag :li do
        @context.link_to(compute_name(element), compute_path(element), element.options)
      end
    end
  end
end
