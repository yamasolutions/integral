import React from 'react';
import ReactDOM from 'react-dom';
import classnames from 'classnames';

import { PanelBody, ToggleControl } from '@wordpress/components';
import { InnerBlocks, InspectorControls, PlainText } from '@wordpress/block-editor'

const name = 'integral/foundation-accordion';

export { name };

export const settings = {
	title: 'Accordion',
	description:  'Accordions are elements that help you organize and navigate multiple documents in a single container. to help draw attention to content.',
  icon: 'list-view',
  category: 'layout',
  attributes: {
    title: {
      source: 'text',
      selector: '.accordion-title'
    },
    isOpenByDefault: {
      type: 'boolean',
      default: false
    }
  },
  edit({attributes, className, setAttributes, isSelected}) {
    let inlineStyle = (isSelected || attributes.isOpenByDefault) ? { display: 'block' } : {};

    return [
			<InspectorControls>
				<PanelBody title={ 'Accordion settings' }>
					<ToggleControl
						label={ 'Open by default' }
            onChange={ content => setAttributes({ isOpenByDefault: content }) }
            checked={ attributes.isOpenByDefault }
					/>

				</PanelBody>
			</InspectorControls>,
      <div className={ 'accordion ' + className }>
        <div className='accordion-item'>
          <PlainText
            onChange={ content => setAttributes({ title: content }) }
            value={ attributes.title }
            placeholder="Your accordion title"
            className="accordion-title"
          />
          <div className="accordion-content" style={ inlineStyle }>
            <InnerBlocks/>
          </div>
        </div>
      </div>
    ];
  },
  save({ attributes }) {
    let activeClass = attributes.isOpenByDefault ? "is-active" : "";

    return (
      <ul className="accordion" data-accordion data-multi-expand="true" data-allow-all-closed="true">
        <li className= { classnames("accordion-item", activeClass) } data-accordion-item>
          <a href="#" className="accordion-title">{ attributes.title }</a>

          <div className="accordion-content" data-tab-content>
            <InnerBlocks.Content />
          </div>
        </li>
      </ul>
    );
  }
};

