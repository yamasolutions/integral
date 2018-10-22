# Integral namespace
module Integral
  # Record PaperTrail of Integral::User
  class UserVersion < Version
    self.table_name = :integral_user_versions
    self.sequence_name = :integral_user_versions_id_seq
  end
end
