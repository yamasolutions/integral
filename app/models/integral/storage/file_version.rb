module Integral
  module Storage
    # Record PaperTrail of Integral::File
    class FileVersion < Version
      self.table_name = :integral_file_versions
      self.sequence_name = :integral_file_versions_id_seq
    end
  end
end
