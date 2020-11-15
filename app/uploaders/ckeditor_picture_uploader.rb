# :nocov:
# CKEditor picture uploader
class CkeditorPictureUploader < CarrierWave::Uploader::Base
  include Ckeditor::Backend::CarrierWave
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptimizer

  # Process images in the background
  process optimize: [{ quality: Integral.image_compression_quality }]
  process resize_to_limit: Integral.editor_image_size_limit

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/ckeditor/pictures/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  process :extract_dimensions

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fill: [118, 100]
  end

  # Extensions which are allowed to be uploaded.
  def extension_white_list
    Ckeditor.image_file_types
  end

  # Content types which are allowed to be uploaded.
  #
  # # TODO: Properly validate picture uploads (server-side & client side)
  # For some reason the extension_white_list is not getting hit when images are uploaded through
  # the editor. content_type_whitelist was added to counter that however it does not take into
  # account application/octet-stream. So it is being commented out
  # Clientside check should be added in CKEditor & this should be readded to include octet-stream
  # or the extension_white_list fixed.
  #
  # def content_type_whitelist
  #   /image\//
  # end
end
