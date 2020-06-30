# Integral namespace
module Integral
  # Record PaperTrail of Integral::Category
  class CategoryVersion < Version
    self.table_name = :integral_category_versions
    self.sequence_name = :integral_category_versions_id_seq
  end
end
