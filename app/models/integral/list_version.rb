# Integral namespace
module Integral
  # Record PaperTrail of Integral::List
  class ListVersion < Version
    self.table_name = :integral_list_versions
    self.sequence_name = :integral_list_versions_id_seq
  end
end
