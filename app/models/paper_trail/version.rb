# :nocov:
# Paper Trail - https://github.com/airblade/paper_trail
module PaperTrail
  # Base Version class for tracking model activity
  class Version < ActiveRecord::Base
    include PaperTrail::VersionConcern
    self.abstract_class = true
  end
end
