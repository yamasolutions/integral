import React from 'react';
import ReactDOM from 'react-dom';

import { widget as icon } from '@wordpress/icons';

const name = 'integral/contact-form';

export { name };

export const settings = {
	title: 'Contact Form',
	description:  'Allow users to get in touch using a contact form.',
  icon,
  category: 'widgets',
  edit({attributes, className, setAttributes, isSelected}) {
    return ([
      <div className={ className }>
        <p>Contact Form</p>
        <div className='contact-form-outline'>
        </div>
      </div>
    ]);
  }
};
