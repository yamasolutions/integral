# Integral namespace
module Integral
  # Record PaperTrail of Integral::Image
  class ImageVersion < Version
    self.table_name = :integral_image_versions
    self.sequence_name = :integral_image_versions_id_seq
  end
end
