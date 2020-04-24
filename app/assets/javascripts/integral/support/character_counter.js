// This was originally sourced from MaterializeCSS & edited

jQuery.fn.characterCounter = function(){
  return this.each(function(){
    var $input = $(this);
    var $counterElement = $input.parent().find('span[class="character-counter"]');

    // character counter has already been added appended to the parent container
    if ($counterElement.length) {
      return;
    }

    var itHasLengthAttribute = $input.attr('maxlength') != undefined;
    var itIsntDisabled = $input.attr('data-character-counter') != 'false';
    var itIsEnabled = $input.attr('data-character-counter') == 'true';

    if ((itHasLengthAttribute) && (itIsntDisabled) || itIsEnabled) {
      $input.on('input', updateCounter);
      $input.on('focus', updateCounter);
      $input.on('blur', removeCounterElement);

      addCounterElement($input);
    }
  });
};

function updateCounter(){
  var maxLength = $(this).attr('maxlength');
  var actualLength = this.value.length;

  if (maxLength === undefined) {
    var formattedCount = actualLength;
  } else {
    var isValidLength = actualLength <= maxLength;
    var formattedCount = actualLength + '/' + maxLength;
    addInputStyle(isValidLength, $(this));
  }

  $(this).parent().find('span[class="character-counter"]').html(formattedCount);
}

function addCounterElement($input) {
  var $counterElement = $input.parent().find('span[class="character-counter"]');

  if ($counterElement.length) {
    return;
  }

  $counterElement = $('<span/>')
    .addClass('character-counter')
    .css('float','right')
    .css('font-size','12px')
    .css('margin-top', '-.5rem')
    .css('height', 1);

  $input.after($counterElement);
}

function removeCounterElement(){
  $(this).parent().find('span[class="character-counter"]').html('');
}

function addInputStyle(isValidLength, $input){
  var inputHasInvalidClass = $input.hasClass('invalid');
  if (isValidLength && inputHasInvalidClass) {
    $input.removeClass('invalid');
  }
  else if(!isValidLength && !inputHasInvalidClass){
    $input.removeClass('valid');
    $input.addClass('invalid');
  }
}

