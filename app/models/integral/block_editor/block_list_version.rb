# Integral namespace
module Integral
  module BlockEditor
    # Record PaperTrail of Integral::BlockEditor::BlockList
    class BlockListVersion < Version
      self.table_name = :integral_block_list_versions
      self.sequence_name = :integral_block_list_versions_id_seq
    end
  end
end
