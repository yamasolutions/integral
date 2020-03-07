# frozen_string_literal: true

class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase
  # include Ckeditor::Backend::ActiveStorage # TODO: AS-SWITCH

  delegate :url, :current_path, :content_type, to: :data
  # attr_accessor :data # TODO: AS-SWITCH

  has_one_attached :storage_data
end
