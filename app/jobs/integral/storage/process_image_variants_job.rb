module Integral
  module Storage
    class ProcessImageVariantsJob < ApplicationJob
      discard_on ActiveRecord::RecordNotFound

      def perform(file)
        return if file.deleted? # Return early when files have already been soft-deleted

        Integral.image_sizes.values.each do |size|
          file.attachment.variant(Integral.image_transformation_options.merge!(resize_to_limit: size)).processed
        end
      end
    end
  end
end
