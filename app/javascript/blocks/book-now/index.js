import React from 'react';
import ReactDOM from 'react-dom';

import { shipping as icon } from '@wordpress/icons';

const name = 'hanazono/book-now';

export { name };

export const settings = {
	title: 'Book Now',
	description:  'Display book now block.',
  icon,
  category: 'widgets',
  edit({attributes, className, setAttributes, isSelected}) {
    return ([
      <div className={ className }>
        <p>Book Now</p>
        <div className='book-now-outline'>
        </div>
      </div>
    ]);
  }
};
