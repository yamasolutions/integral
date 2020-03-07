# frozen_string_literal: true

class Ckeditor::Picture < Ckeditor::Asset
  mount_uploader :data, CkeditorPictureUploader, mount_on: :data_file_name
  process_in_background :data

  def url_content
    # rails_representation_url(storage_data.variant(resize: '800>').processed, only_path: true) # TODO: AS-SWITCH
    url
  end

  def url_thumb
    return url(:thumb) if url(:thumb)

    # rails_representation_url(storage_data.variant(resize: '118x100').processed, only_path: true)  # TODO: AS-SWITCH
    url
  end
end
