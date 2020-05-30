class BlockEditorInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options)
    # require 'pry'; binding.pry
    #
    #
    maximize_button = content_tag('button', content_tag(:i, nil, class: 'fa fa-window-maximize'), { type: :button, class: 'button clear block-editor-size-toggle', data: { target: 'hello.maximize', action: 'click->hello#maximize' } })
    minimize_button = content_tag('button', content_tag(:i, nil, class: 'fa fa-window-minimize'), { type: :button, class: 'button clear block-editor-size-toggle hide', data: { target: 'hello.minimize', action: 'click->hello#minimize' } })

    minimize_button.concat(maximize_button).concat(content_tag('div', nil, { id: 'getdave-sbe-block-editor', class: 'getdave-sbe-block-editor', data: { target: 'hello.output' } })).prepend(super)

    # %div{data: { controller: 'hello' } }
    #   %div{data: { target: 'hello.input' } }
    #   #getdave-sbe-block-editor.getdave-sbe-block-editor{data: { target: 'hello.output' } }
  end
end
