# Handles slug generation
# https://trafficgenerationcafe.com/what-is-slug/
#
# @usage Give an the output data-slugify attribute, setting the value as the selector to the input field
# <input type='text' data-slugify='#input-field' />
class this.SlugGenerator
  # Checks for any slugs on the page and initializes SlugGenerator
  @check_for_slugs: ->
    for slug in $('[data-slugify]')
      slug = $(slug)
      sluggable = $(slug.data('slugify'))
      new SlugGenerator(sluggable, slug) if sluggable.length != 0

  # Slugs given strings
  #
  # @param sluggable [String] string to turn into a valid slug
  # @return [String] valid slug
  @slugify: (sluggable) ->
    sluggable.toString().toLowerCase()
    .replace(/\s+/g, '-')                 # Replace spaces with -
    .replace(/[^\u0100-\uFFFF\w\-]/g,'-') # Remove all non-word chars ( fix for UTF-8 chars )
    .replace(/\-\-+/g, '-')               # Replace multiple - with single -
    .replace(/^-+/, '')                   # Trim - from start of text
    .replace(/-+$/, '')

  # Generates slugs from a given inputField value and sends the slug to outputField.
  # Also monitors outputField to make sure if the slug is editted to is still a valid slug
  #
  # @param inputField [$Object] field to generate the slug from
  # @param outputField [$Object] field to send the generated slug to
  constructor: (inputField, outputField) ->
    @inputField = inputField
    @outputField = outputField

    @setupEvents()

  # Sets event listeners on slug fields
  setupEvents: =>
    @inputField.change =>
      if @outputField.val() == ''
        @setSlug(@inputField.val())

    @outputField.change =>
      @setSlug(@outputField.val())

  # Sets event listeners on slug fields
  setSlug: (sluggable) =>
    @outputField.val(SlugGenerator.slugify(sluggable))

