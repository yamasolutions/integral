module Integral
  module Storage
    class ProcessImageVariantsJob < ApplicationJob
      def perform(file)
        return if file.nil? # Return early when files have already been removed

        Integral.image_sizes.values.each do |size|
          file.attachment.variant(Integral.image_transformation_options.merge!(resize_to_limit: size)).processed
        end
      end
    end
  end
end
