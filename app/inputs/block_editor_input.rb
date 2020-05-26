class BlockEditorInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options)
    # require 'pry'; binding.pry
    content_tag('div', nil, { id: 'getdave-sbe-block-editor', class: 'getdave-sbe-block-editor', data: { target: 'hello.output' } }).prepend(super)

    # %div{data: { controller: 'hello' } }
    #   %div{data: { target: 'hello.input' } }
    #   #getdave-sbe-block-editor.getdave-sbe-block-editor{data: { target: 'hello.output' } }
  end
end
