class BlockEditorInput < SimpleForm::Inputs::TextInput
  def options
    defaults = {
      label: false,
      wrapper_html: { data: { controller: 'block-editor' }},
      input_html: { data: { target: 'block-editor.input' }}
    }

    defaults.deep_merge(super)
  end

  def input(wrapper_options)
    maximize_button = content_tag('button', content_tag(:i, nil, class: 'fa fa-window-maximize'), { type: :button, class: 'button clear block-editor-size-toggle', data: { target: 'block-editor.maximize', action: 'click->block-editor#maximize' } })
    minimize_button = content_tag('button', content_tag(:i, nil, class: 'fa fa-window-minimize'), { type: :button, class: 'button clear block-editor-size-toggle hide', data: { target: 'block-editor.minimize', action: 'click->block-editor#minimize' } })

    minimize_button.concat(maximize_button).concat(content_tag('div', nil, { id: 'getdave-sbe-block-editor', class: 'getdave-sbe-block-editor', data: { target: 'block-editor.output' } })).prepend(super)
  end
end
