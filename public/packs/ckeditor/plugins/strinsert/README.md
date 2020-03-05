StrInsert (String Insert)
=========================

Dropdown for CKEditor to insert custom strings.

Allows you to create a custom dropdown added to the ckeditor4 toolbar, which outputs a text string (or whatever needed) to the editor.  This is useful for making it easy for people to use tokens or merge tags in the documents they edit.

Original repository name custom-dropdown-ckeditor4.

By Stuart Sillitoe (57u) and Marcus Bointon (Synchro).

 * https://github.com/57u/custom-dropdown-ckeditor4
 * https://github.com/Synchro/custom-dropdown-ckeditor4

##Installation

1. Place the strinsert folder in the ckeditor/plugins/ directory.
2. Edit your config.js file so as to add strinsert to the [extraPlugins configuration](http://docs.ckeditor.com/#!/api/CKEDITOR.config-cfg-extraPlugins)
```
CKEDITOR.editorConfig = function( config ) {

    // ...

    // Register the strinsert plugin
	config.extraPlugins = 'strinsert';
};
```

Note: StrInsert is added to the 'insert' toolbar group by default, but you can change this in your [toolbarGroups configuration](http://docs.ckeditor.com/#!/api/CKEDITOR.config-cfg-toolbarGroups).  For more information, see also the [developer guide for toolbars](http://docs.ckeditor.com/#!/guide/dev_toolbar) and the [toolbar sample](http://ckeditor.com/latest/samples/plugins/toolbar/toolbar.html).

## Configuration

Add the strings you are going to insert to your configuration, like this:

```
CKEDITOR.editorConfig = function( config ) {

    // ...
    config.strinsert_strings = [
			{'name': 'Name', 'value': '*|VALUE|*'},
			{'name': 'Group 1'},
			{'name': 'Another name', 'value': 'totally_different', 'label': 'Good looking'},
		];
};
```

This list of dicts define the strings to choose from to insert into the editor.

Each insertable string dict is defined by three possible keys:
 * 'value': The value to insert.
 * 'name': The name for the string to use in the dropdown.
 * 'label': The voice label (also used as the tooltip title) for the string.

Only the value to insert is required to define an insertable string, the value will be used as the name (and the name as the label) if other keys are not provided.

If the value key is *not* defined and the name key is, then a group header with the given name will be provided in the dropdown box.  This heading is not clickable and does not insert, it is for organizational purposes only.

###Additional configuration

You can additionally set name shown for the dropdown button with **config.strinsert_button_label** ('Insert' by default) and the title/tooltip text with  **config.strinsert_button_title** and the voice label text **config.strinsert_button_voice** (both 'Insert content' by default).

Put all together the strinsert section of your config.js file might look like this:

```
CKEDITOR.editorConfig = function( config ) {
    // ...
    config.extraPlugins = 'strinsert';
    config.strinsert_strings = [
        {'value': '*|FIRSTNAME|*', 'name': 'First name'},
        {'value': '*|LASTNAME|*', 'name': 'Last name'},
        {'value': '*|INVITEURL|*', 'name': 'Activore invite URL'},
    ];
    config.strinsert_button_label = 'Tokens';
    config.strinsert_button_title = config.strinsert_button_voice = 'Insert token';
};
```
