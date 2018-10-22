# CKEditor picture
class Ckeditor::Picture < Ckeditor::Asset
  mount_uploader :data, CkeditorPictureUploader, mount_on: :data_file_name
  process_in_background :data

  # Integral does not create a content version so this is basically an alias method for CKEditor
  #
  # @return [String] URL of picture
  def url_content
    url
  end

  # Before the picture is processed in the background thumbnail URL may not be available
  #
  # @return [String] URL of picture
  def url_thumb
    return url(:thumb) if url(:thumb)

    url
  end
end
