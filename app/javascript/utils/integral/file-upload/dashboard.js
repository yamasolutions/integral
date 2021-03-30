const Dashboard = require('@uppy/dashboard')

class IntegralDashboard extends Dashboard {
  constructor(uppy, opts) {
    const defaultOptions = {
      showProgressDetails: true,
      proudlyDisplayPoweredByUppy: false,
      metaFields: [
        {
          id: 'name',
          name: 'Title',
          render ({ value, onChange, fieldCSSClasses }, h) {
            const point = value.lastIndexOf('.')
            const name = value.slice(0, point)
            const ext = value.slice(point + 1)
            return h('input', {
              class: fieldCSSClasses.text,
              type: 'text',
              value: name,
              onChange: (event) => onChange(event.target.value.trim() + '.' + ext),
              'data-uppy-super-focusable': true
            })
          }
        },
        { id: 'description', name: 'Description', placeholder: 'Describe what the file is about' }
      ]
    };

    super(uppy, Object.assign({}, defaultOptions, opts));
  }
};

export default IntegralDashboard;
